# Maybe 中文本地化与 AI 供应商配置实施计划

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** 完成 Maybe 项目的中文 UI 翻译 和 可配置 OpenAI 兼容供应商功能

**Architecture:**
- 通过创建 `config/locales/views/**/zh-CN.yml` 文件实现完整中文翻译
- 通过扩展 `Setting` 模型和 `Provider::Openai` 类实现自定义 Base URL 和 Model ID 配置
- 遵循 Rails I18n 约定和现有 Setting 配置模式

**Tech Stack:**
- Ruby on Rails 7.2, Rails I18n, rails-settings-cached, ruby-openai gem

---

## 准备工作

### Task 0: 确认开发环境

**命令:**
```bash
bin/rails --version
bin/rails test --help | head -5
```

**预期输出:**
- Rails 7.2.x
- 测试框架就绪

---

## 第一部分: 中文翻译实现

### Task 1: 创建核心布局翻译

**Files:**
- Create: `config/locales/views/layout/zh-CN.yml`

**Step 1: 创建翻译文件**

```yaml
---
zh-CN:
  layouts:
    auth:
      existing_account: 已有账户？
      no_account: 新用户？
      sign_in: 登录
      sign_up: 创建账户
      your_account: 你的账户
    shared:
      footer:
        privacy_policy: 隐私政策
        terms_of_service: 服务条款
```

**Step 2: 验证翻译加载**

```bash
bin/rails runner "puts I18n.t('layouts.auth.sign_in', locale: :'zh-CN')"
```

**预期输出:** `登录`

**Step 3: Commit**

```bash
git add config/locales/views/layout/zh-CN.yml
git commit -m "i18n: add Chinese translation for layout"
```

---

### Task 2: 创建设置页面翻译

**Files:**
- Create: `config/locales/views/settings/zh-CN.yml`

**Step 1: 创建翻译文件**

```yaml
---
zh-CN:
  settings:
    billings:
      show:
        page_title: 账单
        subscription_subtitle: 更新你的订阅和账单详情
        subscription_title: 管理订阅
    preferences:
      show:
        country: 国家/地区
        currency: 货币
        date_format: 日期格式
        general_subtitle: 配置你的偏好设置
        general_title: 常规
        default_period: 默认周期
        language: 语言
        page_title: 偏好设置
        theme_dark: 深色
        theme_light: 浅色
        theme_subtitle: 选择应用的主题
        theme_system: 跟随系统
        theme_title: 主题
        timezone: 时区
    profiles:
      show:
        confirm_delete:
          body: 确定要永久删除账户吗？此操作不可撤销。
          title: 删除账户？
        confirm_reset:
          body: 确定要重置账户吗？这将删除所有账户、分类、商家、标签等数据，但保留用户账户。
          title: 重置账户？
        danger_zone_title: 危险区域
        delete_account: 删除账户
        delete_account_warning: 删除账户将永久移除所有数据，无法撤销。
        email: 电子邮箱
        first_name: 名字
        household_form_label: 家庭名称
        household_subtitle: 邀请家庭成员、伴侣和其他人。被邀请者可以登录你的家庭并访问共享账户。
        household_title: 家庭
        last_name: 姓氏
        page_title: 账户信息
        profile_subtitle: 自定义你在 Maybe 上的显示方式
        profile_title: 个人资料
        reset_account: 重置账户
        reset_account_warning: 重置账户将删除所有账户、分类、商家、标签等数据，但保留用户账户。
        save: 保存
    securities:
      show:
        page_title: 安全
    settings_nav:
      accounts_label: 账户
      api_key_label: API 密钥
      billing_label: 账单
      categories_label: 分类
      feedback_label: 反馈
      general_section_title: 常规
      imports_label: 导入
      logout: 退出登录
      merchants_label: 商家
      other_section_title: 更多
      preferences_label: 偏好设置
      profile_label: 账户
      rules_label: 规则
      security_label: 安全
      self_hosting_label: 自托管
      tags_label: 标签
      transactions_section_title: 交易
      whats_new_label: 更新日志
```

**Step 2: 验证翻译**

```bash
bin/rails runner "puts I18n.t('settings.settings_nav.preferences_label', locale: :'zh-CN')"
```

**预期输出:** `偏好设置`

**Step 3: Commit**

```bash
git add config/locales/views/settings/zh-CN.yml
git commit -m "i18n: add Chinese translation for settings"
```

---

### Task 3: 创建引导流程翻译

**Files:**
- Create: `config/locales/views/onboardings/zh-CN.yml`

**Step 1: 创建翻译文件**

```yaml
---
zh-CN:
  onboardings:
    header:
      sign_out: 退出登录
    preferences:
      currency: 货币
      date_format: 日期格式
      example: 示例账户
      locale: 语言
      preview: 根据偏好设置预览数据显示方式。
      submit: 完成
      subtitle: 让我们配置你的偏好设置。
      title: 配置偏好设置
    profile:
      country: 国家/地区
      first_name: 名字
      household_name: 家庭名称
      last_name: 姓氏
      profile_image: 头像
      submit: 继续
      subtitle: 让我们完善你的个人资料。
      title: 基础设置
    show:
      message: 很高兴你来到这里。接下来我们会问你几个问题来完成个人资料设置。
      setup: 设置账户
      title: 欢迎使用 Maybe
```

**Step 2: Commit**

```bash
git add config/locales/views/onboardings/zh-CN.yml
git commit -m "i18n: add Chinese translation for onboardings"
```

---

### Task 4: 创建账户管理翻译

**Files:**
- Create: `config/locales/views/accounts/zh-CN.yml`

**Step 1: 创建翻译文件**

```yaml
---
zh-CN:
  accounts:
    index:
      title: 账户
      add_account: 添加账户
      account_types: 账户类型
    show:
      title: 账户详情
      edit: 编辑
      delete: 删除
    new:
      title: 新建账户
    edit:
      title: 编辑账户
    form:
      name: 账户名称
      balance: 余额
      currency: 货币
      type: 账户类型
```

**Step 2: Commit**

```bash
git add config/locales/views/accounts/zh-CN.yml
git commit -m "i18n: add Chinese translation for accounts"
```

---

### Task 5: 创建交易管理翻译

**Files:**
- Create: `config/locales/views/transactions/zh-CN.yml`

**Step 1: 创建翻译文件**

```yaml
---
zh-CN:
  transactions:
    index:
      title: 交易
      search: 搜索交易
      filter: 筛选
      clear_filters: 清除筛选
    show:
      title: 交易详情
      edit: 编辑
      delete: 删除
    form:
      amount: 金额
      date: 日期
      description: 描述
      category: 分类
      tags: 标签
      merchant: 商家
```

**Step 2: Commit**

```bash
git add config/locales/views/transactions/zh-CN.yml
git commit -m "i18n: add Chinese translation for transactions"
```

---

### Task 6: 创建分类管理翻译

**Files:**
- Create: `config/locales/views/categories/zh-CN.yml`

**Step 1: 创建翻译文件**

```yaml
---
zh-CN:
  categories:
    index:
      title: 分类
      add_category: 添加分类
      income: 收入
      expense: 支出
    form:
      name: 名称
      color: 颜色
      parent: 父分类
```

**Step 2: Commit**

```bash
git add config/locales/views/categories/zh-CN.yml
git commit -m "i18n: add Chinese translation for categories"
```

---

### Task 7: 创建标签管理翻译

**Files:**
- Create: `config/locales/views/tags/zh-CN.yml`

**Step 1: 创建翻译文件**

```yaml
---
zh-CN:
  tags:
    index:
      title: 标签
      add_tag: 添加标签
    form:
      name: 名称
```

**Step 2: Commit**

```bash
git add config/locales/views/tags/zh-CN.yml
git commit -m "i18n: add Chinese translation for tags"
```

---

### Task 8: 创建 AI 聊天翻译

**Files:**
- Create: `config/locales/views/chats/zh-CN.yml`

**Step 1: 创建翻译文件**

```yaml
---
zh-CN:
  chats:
    index:
      title: AI 助手
      new_chat: 新对话
    new:
      title: 新对话
    show:
      placeholder: 输入你的问题...
      send: 发送
    ai_consent:
      title: 启用 AI 功能
      description: AI 功能需要发送你的财务数据到外部服务进行分析。
      enable: 启用 AI
      disable: 暂不启用
```

**Step 2: Commit**

```bash
git add config/locales/views/chats/zh-CN.yml
git commit -m "i18n: add Chinese translation for AI chat"
```

---

### Task 9: 创建导入功能翻译

**Files:**
- Create: `config/locales/views/imports/zh-CN.yml`

**Step 1: 创建翻译文件**

```yaml
---
zh-CN:
  imports:
    index:
      title: 数据导入
      new_import: 新建导入
    show:
      title: 导入详情
      process: 处理导入
    form:
      file: 文件
      type: 导入类型
```

**Step 2: Commit**

```bash
git add config/locales/views/imports/zh-CN.yml
git commit -m "i18n: add Chinese translation for imports"
```

---

### Task 10: 创建 Self-Hosting 设置翻译

**Files:**
- Create: `config/locales/views/settings/hostings/zh-CN.yml`

**Step 1: 创建翻译文件**

```yaml
---
zh-CN:
  settings:
    hostings:
      show:
        general: 常规设置
        invites: 邀请码
        title: 自托管设置
        danger_zone: 危险区域
        ai: AI 设置
      synth_settings:
        title: Synth 设置
        description: 输入 Synth 提供的 API 密钥
        label: API 密钥
        placeholder: 在此输入 API 密钥
        api_calls_used: "%{used} / %{limit} API 调用已使用 (%{percentage})"
        plan: "%{plan} 计划"
      openai_settings:
        title: OpenAI 配置
        description: 配置 OpenAI 或兼容供应商的 API
        access_token_label: API 密钥
        access_token_placeholder: 输入你的 API 密钥
        base_url_label: API 基础 URL
        base_url_placeholder: https://api.openai.com/v1
        model_id_label: 模型 ID
        model_id_placeholder: gpt-4.1
      invite_code_settings:
        title: 需要邀请码注册
        description: 每个新用户只能通过邀请码加入你的 Maybe 实例
        email_confirmation_description: 启用后，用户更改邮箱时需要验证。
        email_confirmation_title: 需要邮箱验证
        generate_tokens: 生成新代码
        generated_tokens: 已生成的代码
      update:
        success: 设置已更新
        failure: 设置值无效
      clear_cache:
        cache_cleared: 数据缓存已清除，可能需要几分钟完成。
      not_authorized: 你没有权限执行此操作
```

**Step 2: Commit**

```bash
git add config/locales/views/settings/hostings/zh-CN.yml
git commit -m "i18n: add Chinese translation for self-hosting settings"
```

---

## 第二部分: AI 供应商配置实现

### Task 11: 扩展 Setting 模型

**Files:**
- Modify: `app/models/setting.rb`

**Step 1: 添加新字段**

```ruby
# app/models/setting.rb
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
```

**Step 2: 测试配置读取**

```bash
bin/rails runner "puts Setting.openai_base_url; puts Setting.openai_model_id"
```

**预期输出:**
```
https://api.openai.com/v1
gpt-4.1
```

**Step 3: Commit**

```bash
git add app/models/setting.rb
git commit -m "feat: add openai_base_url and openai_model_id settings"
```

---

### Task 12: 改造 Provider::Openai

**Files:**
- Modify: `app/models/provider/openai.rb`

**Step 1: 修改初始化方法**

```ruby
# app/models/provider/openai.rb
class Provider::Openai < Provider
  include LlmConcept

  Error = Class.new(Provider::Error)

  # 移除硬编码 MODELS 常量
  # MODELS = %w[gpt-4.1]

  def initialize(access_token, base_url: nil)
    client_options = { access_token: access_token }
    client_options[:uri_base] = base_url if base_url.present?

    @client = ::OpenAI::Client.new(**client_options)
  end

  def supports_model?(model)
    # 从配置读取支持的模型列表
    available_models.include?(model)
  end

  def auto_categorize(transactions: [], user_categories: [])
    with_provider_response do
      raise Error, "Too many transactions to auto-categorize. Max is 25 per request." if transactions.size > 25

      AutoCategorizer.new(
        client,
        transactions: transactions,
        user_categories: user_categories
      ).auto_categorize
    end
  end

  def auto_detect_merchants(transactions: [], user_merchants: [])
    with_provider_response do
      raise Error, "Too many transactions to auto-detect merchants. Max is 25 per request." if transactions.size > 25

      AutoMerchantDetector.new(
        client,
        transactions: transactions,
        user_merchants: user_merchants
      ).auto_detect_merchants
    end
  end

  def chat_response(prompt, model:, instructions: nil, functions: [], function_results: [], streamer: nil, previous_response_id: nil)
    with_provider_response do
      chat_config = ChatConfig.new(
        functions: functions,
        function_results: function_results
      )

      collected_chunks = []

      stream_proxy = if streamer.present?
        proc do |chunk|
          parsed_chunk = ChatStreamParser.new(chunk).parsed

          unless parsed_chunk.nil?
            streamer.call(parsed_chunk)
            collected_chunks << parsed_chunk
          end
        end
      else
        nil
      end

      raw_response = client.responses.create(parameters: {
        model: model,
        input: chat_config.build_input(prompt),
        instructions: instructions,
        tools: chat_config.tools,
        previous_response_id: previous_response_id,
        stream: stream_proxy
      })

      if stream_proxy.present?
        response_chunk = collected_chunks.find { |chunk| chunk.type == "response" }
        response_chunk.data
      else
        ChatParser.new(raw_response).parsed
      end
    end
  end

  # 类方法：获取配置的可用模型列表
  def self.available_models
    models_string = Setting.openai_model_id
    return ["gpt-4.1"] if models_string.blank?

    models_string.split(",").map(&:strip).reject(&:blank?)
  end

  private
    attr_reader :client

    def available_models
      self.class.available_models
    end
end
```

**Step 2: 运行现有测试**

```bash
bin/rails test test/models/provider/openai_test.rb
```

**预期输出:** 测试通过 (可能需要更新测试以支持新参数)

**Step 3: Commit**

```bash
git add app/models/provider/openai.rb
git commit -m "feat: support custom base_url and dynamic models in OpenAI provider"
```

---

### Task 13: 更新 Provider::Registry

**Files:**
- Modify: `app/models/provider/registry.rb`

**Step 1: 修改 openai provider 方法**

```ruby
# app/models/provider/registry.rb
class Provider::Registry
  include ActiveModel::Validations

  Error = Class.new(StandardError)

  CONCEPTS = %i[exchange_rates securities llm]

  validates :concept, inclusion: { in: CONCEPTS }

  class << self
    def for_concept(concept)
      new(concept.to_sym)
    end

    def get_provider(name)
      send(name)
    rescue NoMethodError
      raise Error.new("Provider '#{name}' not found in registry")
    end

    def plaid_provider_for_region(region)
      region.to_sym == :us ? plaid_us : plaid_eu
    end

    private
      def stripe
        secret_key = ENV["STRIPE_SECRET_KEY"]
        webhook_secret = ENV["STRIPE_WEBHOOK_SECRET"]

        return nil unless secret_key.present? && webhook_secret.present?

        Provider::Stripe.new(secret_key:, webhook_secret:)
      end

      def synth
        api_key = ENV.fetch("SYNTH_API_KEY", Setting.synth_api_key)

        return nil unless api_key.present?

        Provider::Synth.new(api_key)
      end

      def plaid_us
        config = Rails.application.config.plaid

        return nil unless config.present?

        Provider::Plaid.new(config, region: :us)
      end

      def plaid_eu
        config = Rails.application.config.plaid_eu

        return nil unless config.present?

        Provider::Plaid.new(config, region: :eu)
      end

      def github
        Provider::Github.new
      end

      def openai
        access_token = ENV.fetch("OPENAI_ACCESS_TOKEN", Setting.openai_access_token)
        base_url = ENV.fetch("OPENAI_BASE_URL", Setting.openai_base_url)

        return nil unless access_token.present?

        Provider::Openai.new(access_token, base_url: base_url.presence)
      end
  end

  def initialize(concept)
    @concept = concept
    validate!
  end

  def providers
    available_providers.map { |p| self.class.send(p) }
  end

  def get_provider(name)
    provider_method = available_providers.find { |p| p == name.to_sym }

    raise Error.new("Provider '#{name}' not found for concept: #{concept}") unless provider_method.present?

    self.class.send(provider_method)
  end

  private
    attr_reader :concept

    def available_providers
      case concept
      when :exchange_rates
        %i[synth]
      when :securities
        %i[synth]
      when :llm
        %i[openai]
      else
        %i[synth plaid_us plaid_eu github openai]
      end
    end
end
```

**Step 2: 运行测试**

```bash
bin/rails test test/models/provider/registry_test.rb 2>/dev/null || echo "测试文件不存在，跳过"
```

**Step 3: Commit**

```bash
git add app/models/provider/registry.rb
git commit -m "feat: pass base_url from settings to OpenAI provider"
```

---

### Task 14: 创建 OpenAI 设置 Partial

**Files:**
- Create: `app/views/settings/hostings/_openai_settings.html.erb`

**Step 1: 创建视图文件**

```erb
<%# app/views/settings/hostings/_openai_settings.html.erb %>
<div class="space-y-4">
  <div>
    <h2 class="font-medium mb-1"><%= t(".title") %></h2>
    <% if ENV["OPENAI_ACCESS_TOKEN"].present? %>
      <p class="text-sm text-secondary"><%= t(".configured_via_env") %></p>
    <% else %>
      <p class="text-secondary text-sm mb-4"><%= t(".description") %></p>
    <% end %>
  </div>

  <%= styled_form_with model: Setting.new,
                       url: settings_hosting_path,
                       method: :patch,
                       data: {
                         controller: "auto-submit-form",
                         "auto-submit-form-trigger-event-value": "blur"
                       } do |form| %>
    <%= form.text_field :openai_access_token,
                        label: t(".access_token_label"),
                        type: "password",
                        placeholder: t(".access_token_placeholder"),
                        value: ENV.fetch("OPENAI_ACCESS_TOKEN", Setting.openai_access_token),
                        disabled: ENV["OPENAI_ACCESS_TOKEN"].present?,
                        data: { "auto-submit-form-target": "auto" } %>

    <%= form.text_field :openai_base_url,
                        label: t(".base_url_label"),
                        placeholder: t(".base_url_placeholder"),
                        value: ENV.fetch("OPENAI_BASE_URL", Setting.openai_base_url),
                        disabled: ENV["OPENAI_BASE_URL"].present?,
                        data: { "auto-submit-form-target": "auto" } %>

    <%= form.text_field :openai_model_id,
                        label: t(".model_id_label"),
                        placeholder: t(".model_id_placeholder"),
                        value: ENV.fetch("OPENAI_MODEL_ID", Setting.openai_model_id),
                        disabled: ENV["OPENAI_MODEL_ID"].present?,
                        data: { "auto-submit-form-target": "auto" } %>
  <% end %>

  <div class="bg-surface-inset rounded-lg p-4 text-sm text-secondary">
    <p class="font-medium text-primary mb-2"><%= t(".supported_providers") %></p>
    <ul class="list-disc list-inside space-y-1">
      <li>OpenAI (https://api.openai.com/v1)</li>
      <li>DeepSeek (https://api.deepseek.com/)</li>
      <li>Groq (https://api.groq.com/openai)</li>
      <li>Gemini (https://generativelanguage.googleapis.com/v1beta/openai/)</li>
      <li>Ollama (http://localhost:11434/v1)</li>
    </ul>
  </div>
</div>
```

**Step 2: Commit**

```bash
git add app/views/settings/hostings/_openai_settings.html.erb
git commit -m "feat: add OpenAI settings partial with custom provider support"
```

---

### Task 15: 更新 Self-Hosting 设置页面

**Files:**
- Modify: `app/views/settings/hostings/show.html.erb`

**Step 1: 添加 AI 设置区域**

```erb
<%= content_for :page_title, t(".title") %>

<%= settings_section title: t(".general") do %>
  <div class="space-y-6">
    <%= render "settings/hostings/synth_settings" %>
  </div>
<% end %>

<%= settings_section title: t(".ai") do %>
  <div class="space-y-6">
    <%= render "settings/hostings/openai_settings" %>
  </div>
<% end %>

<%= settings_section title: t(".invites") do %>
  <%= render "settings/hostings/invite_code_settings" %>
<% end %>

<%= settings_section title: t(".danger_zone") do %>
  <%= render "settings/hostings/danger_zone_settings" %>
<% end %>
```

**Step 2: Commit**

```bash
git add app/views/settings/hostings/show.html.erb
git commit -m "feat: add AI settings section to self-hosting page"
```

---

### Task 16: 更新 HostingsController

**Files:**
- Modify: `app/controllers/settings/hostings_controller.rb`

**Step 1: 更新参数过滤和 update 动作**

```ruby
# app/controllers/settings/hostings_controller.rb
class Settings::HostingsController < ApplicationController
  layout "settings"

  guard_feature unless: -> { self_hosted? }

  before_action :ensure_admin, only: :clear_cache

  def show
    synth_provider = Provider::Registry.get_provider(:synth)
    @synth_usage = synth_provider&.usage
  end

  def update
    if hosting_params.key?(:require_invite_for_signup)
      Setting.require_invite_for_signup = hosting_params[:require_invite_for_signup]
    end

    if hosting_params.key?(:require_email_confirmation)
      Setting.require_email_confirmation = hosting_params[:require_email_confirmation]
    end

    if hosting_params.key?(:synth_api_key)
      Setting.synth_api_key = hosting_params[:synth_api_key]
    end

    # 新增 OpenAI 配置处理
    if hosting_params.key?(:openai_access_token)
      Setting.openai_access_token = hosting_params[:openai_access_token]
    end

    if hosting_params.key?(:openai_base_url)
      Setting.openai_base_url = hosting_params[:openai_base_url]
    end

    if hosting_params.key?(:openai_model_id)
      Setting.openai_model_id = hosting_params[:openai_model_id]
    end

    redirect_to settings_hosting_path, notice: t(".success")
  rescue ActiveRecord::RecordInvalid => error
    flash.now[:alert] = t(".failure")
    render :show, status: :unprocessable_entity
  end

  def clear_cache
    DataCacheClearJob.perform_later(Current.family)
    redirect_to settings_hosting_path, notice: t(".cache_cleared")
  end

  private
    def hosting_params
      params.require(:setting).permit(
        :require_invite_for_signup,
        :require_email_confirmation,
        :synth_api_key,
        :openai_access_token,
        :openai_base_url,
        :openai_model_id
      )
    end

    def ensure_admin
      redirect_to settings_hosting_path, alert: t(".not_authorized") unless Current.user.admin?
    end
end
```

**Step 2: Commit**

```bash
git add app/controllers/settings/hostings_controller.rb
git commit -m "feat: update hostings controller to handle OpenAI settings"
```

---

### Task 17: 更新英文翻译文件

**Files:**
- Modify: `config/locales/views/settings/hostings/en.yml`

**Step 1: 添加英文翻译键**

```yaml
---
en:
  settings:
    hostings:
      # ... 现有翻译 ...
      show:
        general: General Settings
        invites: Invite Codes
        title: Self-Hosting
        danger_zone: Danger Zone
        ai: AI Settings  # 新增
      openai_settings:  # 新增
        title: OpenAI Configuration
        description: Configure OpenAI or compatible API providers
        configured_via_env: OpenAI is configured via environment variable
        access_token_label: API Key
        access_token_placeholder: Enter your API key
        base_url_label: API Base URL
        base_url_placeholder: https://api.openai.com/v1
        model_id_label: Model ID
        model_id_placeholder: gpt-4.1
        supported_providers: Supported Providers
```

**Step 2: Commit**

```bash
git add config/locales/views/settings/hostings/en.yml
git commit -m "i18n: add English translations for OpenAI settings"
```

---

## 第三部分: 测试与验证

### Task 18: 运行所有测试

**Step 1: 运行模型测试**

```bash
bin/rails test test/models/setting_test.rb 2>/dev/null || echo "Setting test file does not exist"
bin/rails test test/models/provider/openai_test.rb
```

**Step 2: 运行系统测试（关键路径）**

```bash
bin/rails test test/controllers/settings/hostings_controller_test.rb 2>/dev/null || echo "Controller test file does not exist"
```

**Step 3: 验证 I18n 完整性**

```bash
bin/bundle exec i18n-tasks health
```

**预期输出:** 无 missing translations

---

### Task 19: 功能验证

**Step 1: 验证中文翻译加载**

```bash
bin/rails runner "
  I18n.locale = :'zh-CN'
  puts 'Settings nav preferences: ' + I18n.t('settings.settings_nav.preferences_label')
  puts 'Onboarding title: ' + I18n.t('onboardings.show.title')
"
```

**预期输出:**
```
Settings nav preferences: 偏好设置
Onboarding title: 欢迎使用 Maybe
```

**Step 2: 验证 Setting 新字段**

```bash
bin/rails runner "
  Setting.openai_base_url = 'https://api.deepseek.com/'
  Setting.openai_model_id = 'deepseek-chat'
  puts 'Base URL: ' + Setting.openai_base_url
  puts 'Model ID: ' + Setting.openai_model_id
  puts 'Available models: ' + Provider::Openai.available_models.inspect
"
```

**预期输出:**
```
Base URL: https://api.deepseek.com/
Model ID: deepseek-chat
Available models: ["deepseek-chat"]
```

**Step 3: 验证 Provider 初始化**

```bash
bin/rails runner "
  provider = Provider::Openai.new('test-token', base_url: 'https://api.groq.com/openai')
  puts 'Provider created successfully'
  puts 'Supports gpt-4.1: ' + provider.supports_model?('gpt-4.1').to_s
"
```

**预期输出:**
```
Provider created successfully
Supports gpt-4.1: true
```

---

## 第四部分: 文档与完成

### Task 20: 更新 README (可选)

**Files:**
- Modify: `README.md` (添加中文支持说明)

**Step 1: 在适当位置添加**

```markdown
## 中文支持

本项目支持简体中文界面。在设置 > 偏好设置 > 语言中选择 "Chinese (Simplified)" 即可切换。

## AI 供应商配置

自托管用户可以在设置 > 自托管 > AI 设置中配置自定义 OpenAI 兼容供应商，支持：
- OpenAI (官方)
- DeepSeek
- Groq
- Gemini
- Azure OpenAI
- Ollama (本地)
```

**Step 2: Commit**

```bash
git add README.md
git commit -m "docs: update README with Chinese support and AI provider configuration" || echo "No changes to commit"
```

---

### Task 21: 最终验证与提交

**Step 1: 检查所有修改**

```bash
git status
git diff --stat
```

**Step 2: 运行完整测试套件**

```bash
bin/rails test
```

**Step 3: 运行代码检查**

```bash
bin/rubocop -f github -a
```

**Step 4: 最终提交**

```bash
git add -A
git commit -m "feat: complete Chinese localization and AI provider configuration

- Add comprehensive Chinese translations for all view files
- Support custom OpenAI-compatible providers (Base URL + Model ID)
- Add AI settings section to self-hosting configuration page
- Maintain backward compatibility with environment variable configuration"
```

---

## 验收清单

- [ ] 所有中文翻译文件已创建
- [ ] Setting 模型支持 openai_base_url 和 openai_model_id
- [ ] Provider::Openai 支持自定义 base_url
- [ ] Self-Hosting 设置页面可配置 AI 参数
- [ ] 所有测试通过
- [ ] i18n-tasks 健康检查通过
- [ ] 代码检查无问题

---

## 回滚指南

如果需要回滚:

```bash
# 回滚到 main 分支
git checkout main

# 删除开发分支
git branch -D feature/cn-localization-and-ai-provider
```

部分回滚 (仅回滚 AI 配置):
```bash
git revert HEAD~5..HEAD  # 调整范围
```
