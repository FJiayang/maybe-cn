require_relative "../test_helper"

class PeriodLocaleTest < Minitest::Test
  def test_period_labels_exist_in_zh_cn
    I18n.with_locale(:'zh-CN') do
      period_keys = %w[last_day current_week last_7_days current_month last_30_days last_90_days current_year last_365_days last_5_years]

      period_keys.each do |key|
        translation_key = "activemodel.labels.period.#{key}.label"
        translation = I18n.t(translation_key, locale: :'zh-CN')
        refute_equal "translation missing: zh-CN.#{translation_key}", translation,
                     "Expected translation for #{translation_key} to exist in zh-CN locale"
      end
    end
  end

  def test_period_label_shorts_exist_in_zh_cn
    I18n.with_locale(:'zh-CN') do
      period_keys = %w[last_day current_week last_7_days current_month last_30_days last_90_days current_year last_365_days last_5_years]

      period_keys.each do |key|
        translation_key = "activemodel.labels.period.#{key}.label_short"
        translation = I18n.t(translation_key, locale: :'zh-CN')
        refute_equal "translation missing: zh-CN.#{translation_key}", translation,
                     "Expected translation for #{translation_key} to exist in zh-CN locale"
      end
    end
  end

  def test_period_comparison_labels_exist_in_zh_cn
    I18n.with_locale(:'zh-CN') do
      period_keys = %w[last_day current_week last_7_days current_month last_30_days last_90_days current_year last_365_days last_5_years]

      period_keys.each do |key|
        translation_key = "activemodel.labels.period.#{key}.comparison_label"
        translation = I18n.t(translation_key, locale: :'zh-CN')
        refute_equal "translation missing: zh-CN.#{translation_key}", translation,
                     "Expected translation for #{translation_key} to exist in zh-CN locale"
      end
    end
  end
end
