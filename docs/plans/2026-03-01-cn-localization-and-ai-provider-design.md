# Maybe 项目中文本地化与 AI 供应商配置改造设计文档

**日期:** 2026-03-01
**目标:** 完成第一期改造，实现完整的中文 UI 支持 和 可配置的 OpenAI 兼容供应商

---

## 1. 项目现状分析

### 1.1 技术栈
- **框架:** Ruby on Rails 7.2.2
- **前端:** Hotwire (Turbo + Stimulus), Tailwind CSS v4
- **AI 集成:** ruby-openai gem
- **配置管理:** rails-settings-cached gem
- **国际化:** Rails I18n (支持 100+ 语言)

### 1.2 当前问题

#### 问题 A: 中文 UI 不完整
- 已有 `config/locales/defaults/zh-CN.yml` 提供 Rails 默认翻译
- 但所有**视图翻译**仅在 `config/locales/views/**/en.yml` 中提供英文版
- 切换语言为中文后，菜单、设置页面等仍显示英文

#### 问题 B: OpenAI 配置硬编码
| 硬编码点 | 位置 | 当前值 |
|---------|------|--------|
| 模型列表 | `Provider::Openai::MODELS` | `%w[gpt-4.1]` |
| 客户端初始化 | `Provider::Openai#initialize` | 仅支持 `access_token` |
| 表单默认值 | `messages/_chat_form.html.erb` | `value: "gpt-4.1"` |
| 配置项 | `Setting` 模型 | 仅 `openai_access_token` |

---

## 2. 设计方案

采用**最小改动方案**，遵循现有架构，不引入不必要的复杂性。

### 2.1 中文翻译实现

**策略:** 创建对应的中文翻译文件，保持与英文文件相同的键结构

**文件清单:**
```
config/locales/views/
├── layout/zh-CN.yml          # 布局相关
├── settings/zh-CN.yml        # 设置页面 (含菜单)
├── onboardings/zh-CN.yml     # 引导流程
├── accounts/zh-CN.yml        # 账户管理
├── transactions/zh-CN.yml    # 交易管理
├── categories/zh-CN.yml      # 分类管理
├── tags/zh-CN.yml            # 标签管理
├── imports/zh-CN.yml         # 数据导入
├── chats/zh-CN.yml           # AI 聊天
├── sessions/zh-CN.yml        # 登录/注册
└── ... (其他)
```

**翻译原则:**
- 使用简体中文，符合中国大陆用户习惯
- 保留专业术语的准确性 (如 "API Key" 保留英文或译为 "API 密钥")
- 保持与界面一致的简洁风格

### 2.2 AI 供应商配置实现

#### 2.2.1 Setting 模型扩展

```ruby
# app/models/setting.rb
class Setting < RailsSettings::Base
  field :synth_api_key, type: :string, default: ENV["SYNTH_API_KEY"]
  field :openai_access_token, type: :string, default: ENV["OPENAI_ACCESS_TOKEN"]

  # 新增字段
  field :openai_base_url, type: :string, default: "https://api.openai.com/v1"
  field :openai_model_id, type: :string, default: "gpt-4.1"
end
```

#### 2.2.2 Provider::Openai 改造

```ruby
# app/models/provider/openai.rb
class Provider::Openai < Provider
  include LlmConcept

  Error = Class.new(Provider::Error)

  # 移除硬编码 MODELS
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

  def self.available_models
    # 支持逗号分隔的多个模型
    Setting.openai_model_id.to_s.split(",").map(&:strip).presence || ["gpt-4.1"]
  end

  private

    def available_models
      self.class.available_models
    end
end
```

#### 2.2.3 Provider::Registry 更新

```ruby
# app/models/provider/registry.rb
def openai
  access_token = ENV.fetch("OPENAI_ACCESS_TOKEN", Setting.openai_access_token)
  base_url = ENV.fetch("OPENAI_BASE_URL", Setting.openai_base_url)

  return nil unless access_token.present?

  Provider::Openai.new(access_token, base_url: base_url.presence)
end
```

#### 2.2.4 设置页面添加配置表单

新增视图文件 `app/views/settings/hostings/_openai_settings.html.erb`:

```erb
<div class="space-y-4">
  <div>
    <h2 class="font-medium mb-1"><%= t(".title") %></h2>
    <% if ENV["OPENAI_ACCESS_TOKEN"].present? %>
      <p class="text-sm text-secondary">已通过环境变量配置 OpenAI</p>
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
                        placeholder: "https://api.openai.com/v1",
                        value: ENV.fetch("OPENAI_BASE_URL", Setting.openai_base_url),
                        disabled: ENV["OPENAI_BASE_URL"].present?,
                        data: { "auto-submit-form-target": "auto" } %>

    <%= form.text_field :openai_model_id,
                        label: t(".model_id_label"),
                        placeholder: "gpt-4.1",
                        value: ENV.fetch("OPENAI_MODEL_ID", Setting.openai_model_id),
                        disabled: ENV["OPENAI_MODEL_ID"].present?,
                        data: { "auto-submit-form-target": "auto" } %>
  <% end %>
</div>
```

更新 `app/views/settings/hostings/show.html.erb` 引入新 partial:

```erb
<%= settings_section title: t(".ai") do %>
  <div class="space-y-6">
    <%= render "settings/hostings/openai_settings" %>
  </div>
<% end %>
```

更新 Controller 支持新参数:

```ruby
# app/controllers/settings/hostings_controller.rb
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
```

#### 2.2.5 添加翻译键

```yaml
# config/locales/views/settings/hostings/zh-CN.yml
zh-CN:
  settings:
    hostings:
      show:
        ai: AI 设置
      openai_settings:
        title: OpenAI 配置
        description: 配置 OpenAI 或兼容供应商的 API
        access_token_label: API 密钥
        access_token_placeholder: 输入你的 API 密钥
        base_url_label: API 基础 URL
        model_id_label: 模型 ID
```

### 2.3 支持的 OpenAI 兼容供应商

配置后可支持以下供应商:

| 供应商 | Base URL 示例 | 说明 |
|-------|--------------|------|
| OpenAI | `https://api.openai.com/v1` | 官方 API |
| DeepSeek | `https://api.deepseek.com/` | 国产大模型 |
| Groq | `https://api.groq.com/openai` | 高速推理 |
| Gemini | `https://generativelanguage.googleapis.com/v1beta/openai/` | Google |
| Azure OpenAI | `https://{resource}.openai.azure.com/` | 微软云服务 |
| 本地 Ollama | `http://localhost:11434/v1` | 本地部署 |

---

## 3. 实施范围

### 3.1 第一阶段（本期）

**中文翻译:**
- [ ] 核心设置页面 (`settings/*`)
- [ ] 主导航菜单 (`layout/*`)
- [ ] 账户管理 (`accounts/*`)
- [ ] 交易管理 (`transactions/*`)
- [ ] 引导流程 (`onboardings/*`)
- [ ] AI 聊天界面 (`chats/*`)

**AI 配置:**
- [ ] Setting 模型新增字段
- [ ] Provider::Openai 改造
- [ ] Provider::Registry 更新
- [ ] 设置页面添加配置表单
- [ ] 添加中文翻译

### 3.2 第二阶段（未来）

- 完整的视图翻译覆盖
- 模型选择下拉菜单（而非手动输入）
- 多供应商配置支持
- 供应商健康检查

---

## 4. 测试策略

### 4.1 中文翻译测试
- 切换语言为 zh-CN，检查各页面显示
- 验证翻译键完整性（使用 i18n-tasks gem）

### 4.2 AI 配置测试
- 配置自定义 Base URL 和 Model ID
- 验证聊天功能正常工作
- 验证自动分类功能正常工作

---

## 5. 风险与回滚

| 风险 | 缓解措施 |
|-----|---------|
| 翻译不完整导致英文残留 | 分阶段翻译，优先核心页面 |
| AI 配置错误导致功能失效 | 保留环境变量配置作为兜底 |
| 自定义供应商 API 差异 | 仅支持 OpenAI 兼容格式，文档说明限制 |

**回滚方案:**
- 翻译问题：删除 zh-CN.yml 文件，回退到英文
- AI 配置问题：恢复 Provider::Openai 原始实现

---

## 6. 验收标准

### 6.1 中文支持
- [ ] 语言切换为中文后，设置页面菜单显示中文
- [ ] 账户、交易、分类等核心页面显示中文
- [ ] 不再出现 "translation missing" 错误

### 6.2 AI 供应商配置
- [ ] 在 Self-Hosting 设置页面可见 AI 配置区域
- [ ] 可配置自定义 Base URL（如 DeepSeek）
- [ ] 可配置自定义 Model ID
- [ ] 配置后 AI 聊天功能正常工作
- [ ] 环境变量仍可作为配置方式

---

## 7. 参考文档

- [ruby-openai gem 文档](https://github.com/alexrudall/ruby-openai)
- [Rails I18n 指南](https://guides.rubyonrails.org/i18n.html)
- [rails-settings-cached](https://github.com/huacnlee/rails-settings-cached)

---

**设计者:** Claude Code
**审核状态:** 待审核
