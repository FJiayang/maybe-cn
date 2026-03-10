require "test_helper"

class PeriodTest < ActiveSupport::TestCase
  test "raises validation error when start_date or end_date is missing" do
    error = assert_raises(ActiveModel::ValidationError) do
      Period.new(start_date: nil, end_date: nil)
    end

    assert_includes error.message, "Start date can't be blank"
    assert_includes error.message, "End date can't be blank"
  end

  test "raises validation error when start_date is not before end_date" do
    error = assert_raises(ActiveModel::ValidationError) do
      Period.new(start_date: Date.current, end_date: Date.current - 1.day)
    end

    assert_includes error.message, "Start date must be before end date"
  end

  test "can create custom period" do
    period = Period.new(start_date: Date.current - 15.days, end_date: Date.current)
    assert_equal "Custom Period", period.label
  end

  test "from_key returns period for valid key" do
    period = Period.from_key("last_30_days")
    assert_equal 30.days.ago.to_date, period.start_date
    assert_equal Date.current, period.end_date
  end

  test "from_key with invalid key and no fallback raises error" do
    error = assert_raises(Period::InvalidKeyError) do
      Period.from_key("invalid_key")
    end
  end

  test "label returns correct label for known period" do
    period = Period.from_key("last_30_days")
    assert_equal "Last 30 Days", period.label
  end

  test "label returns Custom Period for unknown period" do
    period = Period.new(start_date: Date.current - 15.days, end_date: Date.current)
    assert_equal "Custom Period", period.label
  end

  test "comparison_label returns correct label for known period" do
    period = Period.from_key("last_30_days")
    assert_equal "vs. last month", period.comparison_label
  end

  test "comparison_label returns date range for unknown period" do
    start_date = Date.current - 15.days
    end_date = Date.current
    period = Period.new(start_date: start_date, end_date: end_date)
    expected = "#{start_date.strftime("%b %d, %Y")} to #{end_date.strftime("%b %d, %Y")}"
    assert_equal expected, period.comparison_label
  end

  test "label returns Chinese label when locale is zh-CN" do
    I18n.with_locale(:'zh-CN') do
      period = Period.from_key("last_30_days")
      assert_equal "最近 30 天", period.label
    end
  end

  test "label_short returns Chinese short label when locale is zh-CN" do
    I18n.with_locale(:'zh-CN') do
      period = Period.from_key("last_30_days")
      assert_equal "30天", period.label_short
    end
  end

  test "comparison_label returns Chinese comparison label when locale is zh-CN" do
    I18n.with_locale(:'zh-CN') do
      period = Period.from_key("last_30_days")
      assert_equal "与上月相比", period.comparison_label
    end
  end

  test "all period labels are translated in zh-CN" do
    I18n.with_locale(:'zh-CN') do
      expected_labels = {
        "last_day" => "最近 1 天",
        "current_week" => "本周",
        "last_7_days" => "最近 7 天",
        "current_month" => "本月",
        "last_30_days" => "最近 30 天",
        "last_90_days" => "最近 90 天",
        "current_year" => "今年",
        "last_365_days" => "最近 365 天",
        "last_5_years" => "最近 5 年"
      }

      expected_labels.each do |key, expected_label|
        period = Period.from_key(key)
        assert_equal expected_label, period.label, "Expected #{key} to translate to #{expected_label}"
      end
    end
  end
end
