module SettingsHelper
  SETTINGS_ORDER = [
    { name_key: "helpers.settings.menu.account", path: :settings_profile_path },
    { name_key: "helpers.settings.menu.preferences", path: :settings_preferences_path },
    { name_key: "helpers.settings.menu.security", path: :settings_security_path },
    { name_key: "helpers.settings.menu.self_hosting", path: :settings_hosting_path, condition: :self_hosted? },
    { name_key: "helpers.settings.menu.api_key", path: :settings_api_key_path },
    { name_key: "helpers.settings.menu.billing", path: :settings_billing_path, condition: :not_self_hosted? },
    { name_key: "helpers.settings.menu.accounts", path: :accounts_path },
    { name_key: "helpers.settings.menu.imports", path: :imports_path },
    { name_key: "helpers.settings.menu.tags", path: :tags_path },
    { name_key: "helpers.settings.menu.categories", path: :categories_path },
    { name_key: "helpers.settings.menu.rules", path: :rules_path },
    { name_key: "helpers.settings.menu.merchants", path: :family_merchants_path },
    { name_key: "helpers.settings.menu.whats_new", path: :changelog_path },
    { name_key: "helpers.settings.menu.feedback", path: :feedback_path }
  ]

  def adjacent_setting(current_path, offset)
    visible_settings = SETTINGS_ORDER.select { |setting| setting[:condition].nil? || send(setting[:condition]) }
    current_index = visible_settings.index { |setting| send(setting[:path]) == current_path }
    return nil unless current_index

    adjacent_index = current_index + offset
    return nil if adjacent_index < 0 || adjacent_index >= visible_settings.size

    adjacent = visible_settings[adjacent_index]

    render partial: "settings/settings_nav_link_large", locals: {
      path: send(adjacent[:path]),
      direction: offset > 0 ? "next" : "previous",
      title: I18n.t(adjacent[:name_key])
    }
  end

  def settings_section(title:, subtitle: nil, &block)
    content = capture(&block)
    render partial: "settings/section", locals: { title: title, subtitle: subtitle, content: content }
  end

  def settings_nav_footer
    previous_setting = adjacent_setting(request.path, -1)
    next_setting = adjacent_setting(request.path, 1)

    content_tag :div, class: "hidden md:flex flex-row justify-between gap-4" do
      concat(previous_setting)
      concat(next_setting)
    end
  end

  def settings_nav_footer_mobile
    previous_setting = adjacent_setting(request.path, -1)
    next_setting = adjacent_setting(request.path, 1)

    content_tag :div, class: "md:hidden flex flex-col gap-4" do
      concat(previous_setting)
      concat(next_setting)
    end
  end

  private
    def not_self_hosted?
      !self_hosted?
    end
end
