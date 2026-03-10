module Localize
  extend ActiveSupport::Concern

  included do
    before_action :set_locale
    around_action :switch_timezone
  end

  private
    def set_locale
      I18n.locale = current_family_locale || I18n.default_locale
    end

    def switch_timezone(&action)
      timezone = Current.family.try(:timezone) || Time.zone
      Time.use_zone(timezone, &action)
    end

    def current_family_locale
      Current.family&.locale || family_locale_from_session
    end

    def family_locale_from_session
      return unless respond_to?(:find_session_by_cookie, true)

      session_record = find_session_by_cookie
      Current.session ||= session_record

      session_record&.user&.family&.locale
    end
end
