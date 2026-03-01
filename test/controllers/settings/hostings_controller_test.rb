require "test_helper"
require "ostruct"

class Settings::HostingsControllerTest < ActionDispatch::IntegrationTest
  include ProviderTestHelper

  setup do
    sign_in users(:family_admin)

    @provider = mock
    Provider::Registry.stubs(:get_provider).with(:synth).returns(@provider)
    @usage_response = provider_success_response(
      OpenStruct.new(
        used: 10,
        limit: 100,
        utilization: 10,
        plan: "free",
      )
    )
  end

  test "cannot edit when self hosting is disabled" do
    with_env_overrides SELF_HOSTED: "false" do
      get settings_hosting_url
      assert_response :forbidden

      patch settings_hosting_url, params: { setting: { require_invite_for_signup: true } }
      assert_response :forbidden
    end
  end

  test "should get edit when self hosting is enabled" do
    @provider.expects(:usage).returns(@usage_response)

    with_self_hosting do
      get settings_hosting_url
      assert_response :success
    end
  end

  test "can update settings when self hosting is enabled" do
    with_self_hosting do
      patch settings_hosting_url, params: { setting: { synth_api_key: "1234567890" } }

      assert_equal "1234567890", Setting.synth_api_key
    end
  end

  test "can clear data cache when self hosting is enabled" do
    account = accounts(:investment)
    holding = account.holdings.first
    exchange_rate = exchange_rates(:one)
    security_price = holding.security.prices.first
    account_balance = account.balances.create!(date: Date.current, balance: 1000, currency: "USD")

    with_self_hosting do
      perform_enqueued_jobs(only: DataCacheClearJob) do
        delete clear_cache_settings_hosting_url
      end
    end

    assert_redirected_to settings_hosting_url
    assert_equal I18n.t("settings.hostings.clear_cache.cache_cleared"), flash[:notice]

    assert_not ExchangeRate.exists?(exchange_rate.id)
    assert_not Security::Price.exists?(security_price.id)
    assert_not Holding.exists?(holding.id)
    assert_not Balance.exists?(account_balance.id)
  end

  test "can clear data only when admin" do
    with_self_hosting do
      sign_in users(:family_member)

      assert_no_enqueued_jobs do
        delete clear_cache_settings_hosting_url
      end

      assert_redirected_to settings_hosting_url
      assert_equal I18n.t("settings.hostings.not_authorized"), flash[:alert]
    end
  end

  # OpenAI configuration tests
  test "can update openai_access_token when self hosting is enabled" do
    with_self_hosting do
      patch settings_hosting_url, params: { setting: { openai_access_token: "sk-test-token" } }

      assert_equal "sk-test-token", Setting.openai_access_token
    end
  end

  test "can update openai_base_url when self hosting is enabled" do
    with_self_hosting do
      patch settings_hosting_url, params: { setting: { openai_base_url: "https://api.deepseek.com/" } }

      assert_equal "https://api.deepseek.com/", Setting.openai_base_url
    end
  end

  test "can update openai_model_id when self hosting is enabled" do
    with_self_hosting do
      patch settings_hosting_url, params: { setting: { openai_model_id: "deepseek-chat" } }

      assert_equal "deepseek-chat", Setting.openai_model_id
    end
  end

  test "can update all openai settings at once" do
    with_self_hosting do
      patch settings_hosting_url, params: {
        setting: {
          openai_access_token: "sk-new-token",
          openai_base_url: "https://api.groq.com/openai",
          openai_model_id: "llama3-8b-8192"
        }
      }

      assert_equal "sk-new-token", Setting.openai_access_token
      assert_equal "https://api.groq.com/openai", Setting.openai_base_url
      assert_equal "llama3-8b-8192", Setting.openai_model_id
    end
  end
end
