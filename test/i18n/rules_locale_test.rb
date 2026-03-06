require_relative "../test_helper"

class RulesLocaleTest < Minitest::Test
  def test_rules_form_translations_exist_in_zh_cn
    I18n.with_locale(:'zh-CN') do
      translation_keys = %w[
        rule_name
        rule_name_placeholder
        if
        then
        for
        add_condition
        add_condition_group
        add_action
        all_past_and_future
        starting_from
      ]

      translation_keys.each do |key|
        translation_key = "rules.form.#{key}"
        translation = I18n.t(translation_key, locale: :'zh-CN')
        refute_equal "translation missing: zh-CN.#{translation_key}", translation,
                     "Expected translation for #{translation_key} to exist in zh-CN locale"
      end
    end
  end
end
