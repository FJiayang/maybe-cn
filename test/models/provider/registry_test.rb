require "test_helper"

class Provider::RegistryTest < ActiveSupport::TestCase
  test "synth configured with ENV" do
    Setting.stubs(:synth_api_key).returns(nil)

    with_env_overrides SYNTH_API_KEY: "123" do
      assert_instance_of Provider::Synth, Provider::Registry.get_provider(:synth)
    end
  end

  test "synth configured with Setting" do
    Setting.stubs(:synth_api_key).returns("123")

    with_env_overrides SYNTH_API_KEY: nil do
      assert_instance_of Provider::Synth, Provider::Registry.get_provider(:synth)
    end
  end

  test "synth not configured" do
    Setting.stubs(:synth_api_key).returns(nil)

    with_env_overrides SYNTH_API_KEY: nil do
      assert_nil Provider::Registry.get_provider(:synth)
    end
  end

  # OpenAI provider tests
  test "returns nil when openai access token is not configured" do
    Setting.stubs(:openai_access_token).returns(nil)

    with_env_overrides OPENAI_ACCESS_TOKEN: nil do
      provider = Provider::Registry.get_provider(:openai)
      assert_nil provider
    end
  end

  test "returns openai provider when access token is configured via setting" do
    with_env_overrides OPENAI_ACCESS_TOKEN: nil, OPENAI_BASE_URL: nil do
      Setting.stubs(:openai_access_token).returns("sk-test-token")
      Setting.stubs(:openai_base_url).returns("https://api.openai.com/v1")

      provider = Provider::Registry.get_provider(:openai)

      assert_instance_of Provider::Openai, provider
    end
  end

  test "passes base_url from settings to openai provider" do
    with_env_overrides OPENAI_ACCESS_TOKEN: nil, OPENAI_BASE_URL: nil do
      Setting.stubs(:openai_access_token).returns("sk-test-token")
      Setting.stubs(:openai_base_url).returns("https://api.deepseek.com/")

      # Verify Provider::Openai is initialized correctly
      Provider::Openai.expects(:new).with("sk-test-token", base_url: "https://api.deepseek.com/").returns(mock)

      Provider::Registry.get_provider(:openai)
    end
  end

  test "environment variable takes precedence over setting for base_url" do
    with_env_overrides OPENAI_ACCESS_TOKEN: "env-token", OPENAI_BASE_URL: "https://api.groq.com/openai" do
      Setting.stubs(:openai_access_token).returns("setting-token")
      Setting.stubs(:openai_base_url).returns("https://api.deepseek.com/")

      # Environment variable should take precedence
      Provider::Openai.expects(:new).with("env-token", base_url: "https://api.groq.com/openai").returns(mock)

      Provider::Registry.get_provider(:openai)
    end
  end

  test "raises error for unknown provider" do
    assert_raises(Provider::Registry::Error) do
      Provider::Registry.get_provider(:unknown_provider)
    end
  end

  # Concept-based provider query tests
  test "returns providers for exchange_rates concept" do
    registry = Provider::Registry.for_concept(:exchange_rates)
    providers = registry.providers

    assert providers.any? { |p| p.is_a?(Provider::Synth) }
  end

  test "returns providers for llm concept" do
    with_env_overrides OPENAI_ACCESS_TOKEN: "test-token" do
      registry = Provider::Registry.for_concept(:llm)
      providers = registry.providers

      assert providers.any? { |p| p.is_a?(Provider::Openai) }
    end
  end
end
