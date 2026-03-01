#!/usr/bin/env ruby
# frozen_string_literal: true

# Phase 3: Replace hardcoded label texts

require 'fileutils'

REPLACEMENTS = {
  # Labels
  'label: "Account value on date"' => 'label: t(".account_value_on_date")',
  'label: "API Key Name"' => 'label: t(".api_key_name")',
  'label: "API Key"' => 'label: t(".api_key")',
  'label: "Address Line 1"' => 'label: t(".address_line_1")',
  'label: "City"' => 'label: t(".city")',
  'label: "State/Region"' => 'label: t(".state_region")',
  'label: "Postal Code"' => 'label: t(".postal_code")',
  'label: "Country"' => 'label: t(".country")',
  'label: "Property type"' => 'label: t(".property_type")',
  'label: "Year Built (optional)"' => 'label: t(".year_built_optional")',
  'label: "Area (optional)"' => 'label: t(".area_optional")',
  'label: "Area Unit"' => 'label: t(".area_unit")',
  'label: "Address"' => 'label: t(".address")',
  'label: "Format"' => 'label: t(".format")',
  'label: "Amount type strategy"' => 'label: t(".amount_type_strategy")',
  'label: "Amount type"' => 'label: t(".amount_type")',
  'label: "Ticker"' => 'label: t(".ticker")',
  'label: "Stock exchange code"' => 'label: t(".stock_exchange_code")',
  'label: "Account (optional)"' => 'label: t(".account_optional")',
  'label: "Name (optional)"' => 'label: t(".name_optional")',
  'label: "Category (optional)"' => 'label: t(".category_optional")',
  'label: "Tags (optional)"' => 'label: t(".tags_optional")',
  'label: "Entity Type"' => 'label: t(".entity_type")',
  'label: "Classification"' => 'label: t(".classification")',
  'label: "Parent category (optional)"' => 'label: t(".parent_category_optional")',
  'label: "Budgeted"' => 'label: t(".budgeted")',
  'label: "Actual"' => 'label: t(".actual")',
  'label: "Outflow transaction"' => 'label: t(".outflow_transaction")',
  'label: "Inflow transaction"' => 'label: t(".inflow_transaction")',
  'label: "Matching method"' => 'label: t(".matching_method")',
  'label: "Matching transaction"' => 'label: t(".matching_transaction")',
  'label: "Target account"' => 'label: t(".target_account")',
  'label: "Ticker symbol"' => 'label: t(".ticker_symbol")',
  'label: "Estimated market value"' => 'label: t(".estimated_market_value")',
  'label: "First name"' => 'label: t(".first_name")',
  'label: "Last name"' => 'label: t(".last_name")',
  'label: "Household name"' => 'label: t(".household_name")',
  'label: "Color theme"' => 'label: t(".color_theme")',
  'label: "Upload CSV"' => 'label: t(".upload_csv")',
  'label: "Copy & Paste"' => 'label: t(".copy_paste")',
  'label: "Budgeted spending"' => 'label: t(".budgeted_spending")',
  'label: "Expected income"' => 'label: t(".expected_income")',
  
  # prompt texts
  'prompt: "Select type"' => 'prompt: t(".select_type")',
  'prompt: "Select format"' => 'prompt: t(".select_format")',
  'prompt: "Select strategy"' => 'prompt: t(".select_strategy")',
  'prompt: "Select convention"' => 'prompt: t(".select_convention")',
  'prompt: "Select column"' => 'prompt: t(".select_column")',
  
  # include_blank texts
  'include_blank: "Leave empty"' => 'include_blank: t(".leave_empty")',
  'include_blank: "Multi-account import"' => 'include_blank: t(".multi_account_import")',
  'include_blank: "(unassigned)"' => 'include_blank: t(".unassigned")',
  
  # placeholder texts
  'placeholder: "First name"' => 'placeholder: t(".first_name_placeholder")',
  'placeholder: "Last name"' => 'placeholder: t(".last_name_placeholder")',
  'placeholder: "Household name"' => 'placeholder: t(".household_name_placeholder")',
  'placeholder: "AAPL"' => 'placeholder: t(".ticker_placeholder")',
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
