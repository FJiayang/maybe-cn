#!/usr/bin/env ruby
# frozen_string_literal: true

# Phase 2: Replace remaining hardcoded English text in view files

require 'fileutils'

# Define additional replacements for more specific text
REPLACEMENTS = {
  # Specific button texts
  'text: "Account Settings"' => 'text: t(".account_settings")',
  'text: "Subscribe and unlock Maybe"' => 'text: t(".subscribe_and_unlock")',
  'text: "Choose plan"' => 'text: t(".choose_plan")',
  'text: "Create API Key"' => 'text: t(".create_api_key")',
  'text: "Create New Key"' => 'text: t(".create_new_key")',
  'text: "Revoke Key"' => 'text: t(".revoke_key")',
  'text: "Copy API Key"' => 'text: t(".copy_api_key")',
  'text: "Continue to API Key Settings"' => 'text: t(".continue_to_settings")',
  'text: "Re-apply rule"' => 'text: t(".reapply_rule")',
  'text: "Create rule"' => 'text: t(".create_rule")',
  'text: "Try Maybe for 14 days"' => 'text: t(".try_for_14_days")',
  'text: "Continue trial"' => 'text: t(".continue_trial")',
  'text: "Back to dashboard"' => 'text: t(".back_to_dashboard")',
  'text: "Create account"' => 'text: t(".create_account")',
  'text: "Import transactions"' => 'text: t(".import_transactions")',
  'text: "Delete account"' => 'text: t(".delete_account")',
  'text: "New balance"' => 'text: t(".new_balance")',
  'text: "New transaction"' => 'text: t(".new_transaction")',
  'text: "Edit account details"' => 'text: t(".edit_account_details")',
  'text: "Update value"' => 'text: t(".update_value")',
  'text: "Open matcher"' => 'text: t(".open_matcher")',
  'text: "Delete all"' => 'text: t(".delete_all")',
  'text: "Delete and reassign"' => 'text: t(".delete_and_reassign")',
  'text: "Export data"' => 'text: t(".export_data")',
  'text: "Delete all rules"' => 'text: t(".delete_all_rules")',
  'text: "New rule"' => 'text: t(".new_rule")',
  'text: "Confirm changes"' => 'text: t(".confirm_changes")',
  'text: "Add condition"' => 'text: t(".add_condition")',
  'text: "Add condition group"' => 'text: t(".add_condition_group")',
  'text: "Add action"' => 'text: t(".add_action")',
  'text: "Edit loan details"' => 'text: t(".edit_loan_details")',
  'text: "View Setup Guide"' => 'text: t(".view_setup_guide")',
  'text: "Refresh Page"' => 'text: t(".refresh_page")',
  'text: "Add transaction"' => 'text: t(".add_transaction")',
  'text: "New import"' => 'text: t(".new_import")',
  'text: "Publish import"' => 'text: t(".publish_import")',
  'text: "Manually configure"' => 'text: t(".manually_configure")',
  'text: "Apply template"' => 'text: t(".apply_template")',
  'text: "Next step"' => 'text: t(".next_step")',
  'text: "New merchant"' => 'text: t(".new_merchant")',
  'text: "Go back"' => 'text: t(".go_back")',
  'text: "New chat"' => 'text: t(".new_chat")',
  'text: "All chats"' => 'text: t(".all_chats")',
  'text: "Start new chat"' => 'text: t(".start_new_chat")',
  'text: "Edit chat title"' => 'text: t(".edit_chat_title")',
  'text: "Delete chat"' => 'text: t(".delete_chat")',
  'text: "Evaluate investment portfolio"' => 'text: t(".evaluate_portfolio")',
  'text: "Show spending insights"' => 'text: t(".show_spending_insights")',
  'text: "Find unusual patterns"' => 'text: t(".find_unusual_patterns")',
  'text: "Fix allocations"' => 'text: t(".fix_allocations")',
  'text: "New budget"' => 'text: t(".new_budget")',
  'text: "View all category transactions"' => 'text: t(".view_all_transactions")',
  'text: "Use defaults (recommended)"' => 'text: t(".use_defaults_recommended")',
  'text: "New category"' => 'text: t(".new_category")',
  'text: "New account"' => 'text: t(".new_account")',
  
  # Help texts
  'help_text: "Choose a descriptive name to help you identify this key later."' => 'help_text: t(".api_key_help_text")',
  
  # btn_text patterns
  'btn_text: "Reset account"' => 'btn_text: t(".reset_account")',
}

def process_file(file_path)
  content = File.read(file_path)
  original_content = content.dup
  
  REPLACEMENTS.each do |old_text, new_text|
    content = content.gsub(old_text, new_text)
  end
  
  if content != original_content
    File.write(file_path, content)
    puts "Updated: #{file_path}"
    return true
  end
  
  false
end

# Process all view files
view_dir = File.expand_path('../app/views', __dir__)
files_modified = 0

Dir.glob(File.join(view_dir, '**/*.erb')).each do |file|
  files_modified += 1 if process_file(file)
end

puts "\nTotal files modified: #{files_modified}"
