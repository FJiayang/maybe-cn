require "test_helper"

class BreadcrumbableTest < ActionDispatch::IntegrationTest
  # Test that breadcrumbs use localized names
  # This test verifies the fix for: breadcrumbs showing "Home > Dashboard" in English

  setup do
    @user = users(:family_admin)
  end

  test "dashboard breadcrumbs are localized" do
    # Set family locale to zh-CN to test localization
    @user.family.update!(locale: "zh-CN")
    sign_in @user

    I18n.with_locale(:'zh-CN') do
      get root_path
      assert_response :success

      # Check that breadcrumbs use translated values
      breadcrumbs = @controller.instance_variable_get(:@breadcrumbs)
      assert_equal "首页", breadcrumbs[0][0]
      assert_equal "仪表板", breadcrumbs[1][0]
    end
  end

  test "accounts breadcrumbs are localized" do
    # Set family locale to zh-CN to test localization
    @user.family.update!(locale: "zh-CN")
    sign_in @user

    I18n.with_locale(:'zh-CN') do
      get accounts_path
      assert_response :success

      breadcrumbs = @controller.instance_variable_get(:@breadcrumbs)
      assert_equal "首页", breadcrumbs[0][0]
      # Second breadcrumb is controller name titleized
    end
  end
end
