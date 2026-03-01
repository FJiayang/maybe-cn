require "test_helper"

class SettingTest < ActiveSupport::TestCase
  # 测试 OpenAI 相关设置的默认值
  test "openai_base_url has correct default value" do
    Setting.openai_base_url = nil
    assert_equal "https://api.openai.com/v1", Setting.openai_base_url
  end

  test "openai_model_id has correct default value" do
    Setting.openai_model_id = nil
    assert_equal "gpt-4.1", Setting.openai_model_id
  end

  # 测试 OpenAI 设置可以被正确保存和读取
  test "can save and retrieve openai_base_url" do
    Setting.openai_base_url = "https://api.deepseek.com/"
    assert_equal "https://api.deepseek.com/", Setting.openai_base_url

    # 清理
    Setting.openai_base_url = nil
  end

  test "can save and retrieve openai_model_id" do
    Setting.openai_model_id = "deepseek-chat"
    assert_equal "deepseek-chat", Setting.openai_model_id

    # 清理
    Setting.openai_model_id = nil
  end

  test "can save and retrieve openai_access_token" do
    Setting.openai_access_token = "sk-test-token"
    assert_equal "sk-test-token", Setting.openai_access_token

    # 清理
    Setting.openai_access_token = nil
  end

  # 测试 synth_api_key 设置
  test "can save and retrieve synth_api_key" do
    Setting.synth_api_key = "test-api-key"
    assert_equal "test-api-key", Setting.synth_api_key

    # 清理
    Setting.synth_api_key = nil
  end

  # 测试布尔设置
  test "can save and retrieve require_invite_for_signup" do
    original = Setting.require_invite_for_signup

    Setting.require_invite_for_signup = true
    assert_equal true, Setting.require_invite_for_signup

    Setting.require_invite_for_signup = original
  end

  test "can save and retrieve require_email_confirmation" do
    original = Setting.require_email_confirmation

    Setting.require_email_confirmation = false
    assert_equal false, Setting.require_email_confirmation

    Setting.require_email_confirmation = original
  end
end
