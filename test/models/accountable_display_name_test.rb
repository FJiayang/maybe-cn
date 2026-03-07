require "test_helper"

class AccountableDisplayNameTest < ActiveSupport::TestCase
  # Test that display_name returns localized names for each account type
  # This test verifies the fix for: account types showing in English in Chinese locale

  test "depository display_name returns localized name" do
    I18n.with_locale("zh-CN") do
      assert_equal "现金", Depository.display_name
    end
  end

  test "crypto display_name returns localized name" do
    I18n.with_locale("zh-CN") do
      assert_equal "加密货币", Crypto.display_name
    end
  end

  test "investment display_name returns localized name" do
    I18n.with_locale("zh-CN") do
      assert_equal "投资", Investment.display_name
    end
  end

  test "property display_name returns localized name" do
    I18n.with_locale("zh-CN") do
      assert_equal "房地产", Property.display_name
    end
  end

  test "vehicle display_name returns localized name" do
    I18n.with_locale("zh-CN") do
      assert_equal "车辆", Vehicle.display_name
    end
  end

  test "credit_card display_name returns localized name" do
    I18n.with_locale("zh-CN") do
      assert_equal "信用卡", CreditCard.display_name
    end
  end

  test "loan display_name returns localized name" do
    I18n.with_locale("zh-CN") do
      assert_equal "贷款", Loan.display_name
    end
  end

  test "other_asset display_name returns localized name" do
    I18n.with_locale("zh-CN") do
      assert_equal "其他资产", OtherAsset.display_name
    end
  end

  test "other_liability display_name returns localized name" do
    I18n.with_locale("zh-CN") do
      assert_equal "其他负债", OtherLiability.display_name
    end
  end

  # Test instance method delegates to class method
  test "instance display_name delegates to class method" do
    depository = Depository.new
    I18n.with_locale("zh-CN") do
      assert_equal Depository.display_name, depository.display_name
    end
  end
end
