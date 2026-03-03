class ApiKey < ApplicationRecord
  belongs_to :user

  # Use Rails built-in encryption for secure storage
  encrypts :display_key, deterministic: true

  # Constants
  SOURCES = [ "web", "mobile" ].freeze

  # Validations
  validates :display_key, presence: true, uniqueness: true
  validates :name, presence: true
  validates :scopes, presence: true
  validates :source, presence: true, inclusion: { in: SOURCES }
  validate :scopes_not_empty
  validate :one_active_key_per_user_per_source, on: :create

  # Callbacks
  before_validation :set_display_key

  # Scopes
  scope :active, -> { where(revoked_at: nil).where("expires_at IS NULL OR expires_at > ?", Time.current) }

  # Class methods
  def self.find_by_value(plain_key)
    return nil unless plain_key

    # Find by encrypted display_key (deterministic encryption allows querying)
    find_by(display_key: plain_key)&.tap do |api_key|
      return api_key if api_key.active?
    end
  end

  def self.generate_secure_key
    SecureRandom.hex(32)
  end

  # Instance methods
  def active?
    !revoked? && !expired?
  end

  def revoked?
    revoked_at.present?
  end

  def expired?
    expires_at.present? && expires_at < Time.current
  end

  def key_matches?(plain_key)
    display_key == plain_key
  end

  def revoke!
    update!(revoked_at: Time.current)
  end

  def update_last_used!
    update_column(:last_used_at, Time.current)
  end

  # Get the plain text API key for display (automatically decrypted by Rails)
  def plain_key
    display_key
  end

  # Temporarily store the plain key for creation flow
  attr_accessor :key

  private

    def set_display_key
      if key.present?
        self.display_key = key
      end
    end

    def scopes_not_empty
      if scopes.blank? || (scopes.is_a?(Array) && (scopes.empty? || scopes.all?(&:blank?)))
        errors.add(:scopes, :must_include_at_least_one_permission)
      elsif scopes.is_a?(Array) && scopes.length > 1
        errors.add(:scopes, :can_only_have_one_permission_level)
      elsif scopes.is_a?(Array) && !%w[read read_write].include?(scopes.first)
        errors.add(:scopes, :must_be_read_or_read_write)
      end
    end

    def one_active_key_per_user_per_source
      if user&.api_keys&.active&.where(source: source)&.where&.not(id: id)&.exists?
        errors.add(:user, :can_only_have_one_active_api_key_per_source, source: source)
      end
    end
end
