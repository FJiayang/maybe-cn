module Localize
  extend ActiveSupport::Concern

  included do
    before_action :set_locale
    around_action :switch_timezone
  end

  private
    def set_locale
      I18n.locale = Current.family&.locale || I18n.default_locale
    end

    def switch_timezone(&action)
      timezone = Current.family.try(:timezone) || Time.zone
      Time.use_zone(timezone, &action)
    end
end
