# Dynamic settings the user can change within the app (helpful for self-hosting)
class Setting < RailsSettings::Base
  cache_prefix { "v1" }

  field :synth_api_key, type: :string, default: ENV["SYNTH_API_KEY"]
  field :openai_access_token, type: :string, default: ENV["OPENAI_ACCESS_TOKEN"]

  # 新增字段 - OpenAI 兼容供应商配置
  field :openai_base_url, type: :string, default: ENV.fetch("OPENAI_BASE_URL", "https://api.openai.com/v1")
  field :openai_model_id, type: :string, default: ENV.fetch("OPENAI_MODEL_ID", "gpt-4.1")

  field :require_invite_for_signup, type: :boolean, default: false
  field :require_email_confirmation, type: :boolean, default: ENV.fetch("REQUIRE_EMAIL_CONFIRMATION", "true") == "true"
end
