module Localize
  extend ActiveSupport::Concern

  included do
    around_action :switch_locale
    around_action :switch_timezone
  end

  private
    def switch_locale(&action)
      locale = if Current.family&.locale
        Current.family.locale
      elsif Rails.env.test? && I18n.locale != I18n.default_locale
        I18n.locale
      elsif Rails.env.test?
        :en
      else
        I18n.default_locale
      end
      I18n.with_locale(locale, &action)
    end

    def switch_timezone(&action)
      timezone = Current.family.try(:timezone) || Time.zone
      Time.use_zone(timezone, &action)
    end
end
