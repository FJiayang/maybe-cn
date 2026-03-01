#!/usr/bin/env ruby
# frozen_string_literal: true

# Phase 4: Replace remaining special hardcoded texts

require 'fileutils'

REPLACEMENTS = {
  # Special text with interpolation - these need manual handling later
  # 'text: "of #{budget.budgeted_spending_money.format}"' => 'text: t(".of_budgeted", amount: budget.budgeted_spending_money.format)',
  # 'text: "of #{bc.budgeted_spending_money.format(precision: 0)}"' => 'text: t(".of_budgeted", amount: bc.budgeted_spending_money.format(precision: 0))',
  # 'text: "New #{account_group.name.downcase.singularize}"' => 'text: t(".new_account_type", type: account_group.name.downcase.singularize)',
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
puts "\nNote: Some texts with Ruby interpolation were not replaced and need manual handling:"
puts "  - budgets/_budget_donut.html.erb: text with interpolation"
puts "  - accounts/_accountable_group.html.erb: dynamic text with interpolation"
