require "application_system_test_case"

class Accounts::DialogCloseTest < ApplicationSystemTestCase
  setup do
    sign_in @user = users(:family_admin)
    Family.any_instance.stubs(:get_link_token).returns("test-link-token")
    visit root_url
  end

  test "closing account modal via close button" do
    # Open the new account modal
    within "[data-controller='DS--tabs']" do
      click_button "All"
      click_link "New account"
    end

    # Verify modal is open
    assert_selector "dialog[open]", wait: 5
    assert_text "你想添加什么？"

    # Click the close button (X icon in top right)
    find("button[data-action*='DS--dialog#close']", match: :first).click

    # Verify modal is closed
    assert_no_selector "dialog[open]", wait: 5
  end

  test "closing account modal via ESC key" do
    # Open the new account modal
    within "[data-controller='DS--tabs']" do
      click_button "All"
      click_link "New account"
    end

    # Verify modal is open
    assert_selector "dialog[open]", wait: 5

    # Press ESC key
    find("body").send_keys(:escape)

    # Verify modal is closed
    assert_no_selector "dialog[open]", wait: 5
  end
end
