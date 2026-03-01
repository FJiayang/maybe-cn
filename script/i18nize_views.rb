#!/usr/bin/env ruby
# frozen_string_literal: true

# This script helps replace hardcoded English text in view files with i18n translation keys

require 'fileutils'

# Define the mapping of hardcoded text to translation keys
# Format: { file_pattern => { old_text => new_text } }
REPLACEMENTS = {
  # Common patterns across all files
  'text: "New"' => 'text: t("common.actions.new")',
  'text: "Edit"' => 'text: t("common.actions.edit")',
  'text: "Delete"' => 'text: t("common.actions.delete")',
  'text: "Save"' => 'text: t("common.actions.save")',
  'text: "Cancel"' => 'text: t("common.actions.cancel")',
  'text: "Confirm"' => 'text: t("common.actions.confirm")',
  'text: "Back"' => 'text: t("common.actions.back")',
  'text: "Next"' => 'text: t("common.actions.next")',
  'text: "Import"' => 'text: t("common.actions.import")',
  'text: "Export"' => 'text: t("common.actions.export")',
  'text: "Search"' => 'text: t("common.actions.search")',
  'text: "Filter"' => 'text: t("common.actions.filter")',
  'text: "Submit"' => 'text: t("common.actions.submit")',
  'text: "Create"' => 'text: t("common.actions.create")',
  'text: "Update"' => 'text: t("common.actions.update")',
  'text: "Remove"' => 'text: t("common.actions.remove")',
  'text: "Dismiss"' => 'text: t("common.actions.dismiss")',
  'text: "Retry"' => 'text: t("common.actions.retry")',
  'text: "Copy"' => 'text: t("common.actions.copy")',
  'text: "Manage"' => 'text: t("common.actions.manage")',
  'text: "Upgrade"' => 'text: t("common.actions.upgrade")',
  'text: "Subscribe"' => 'text: t("common.actions.subscribe")',
  'text: "Sign out"' => 'text: t("common.actions.sign_out")',
  'text: "Sign in"' => 'text: t("common.actions.sign_in")',
  'text: "Sign up"' => 'text: t("common.actions.sign_up")',
  'text: "Try again"' => 'text: t("common.actions.try_again")',
  'text: "Complete setup"' => 'text: t("common.actions.complete_setup")',
  'text: "Publish"' => 'text: t("common.actions.publish")',
  'text: "Check status"' => 'text: t("common.actions.check_status")',
  'text: "Continue"' => 'text: t("common.actions.continue")',
  'text: "Apply"' => 'text: t("common.actions.apply")',
  'text: "Add"' => 'text: t("common.actions.add")',
  'text: "View"' => 'text: t("common.actions.view")',
  'text: "Start"' => 'text: t("common.actions.start")',
  'text: "Stop"' => 'text: t("common.actions.stop")',
  'text: "Enable"' => 'text: t("common.actions.enable")',
  'text: "Disable"' => 'text: t("common.actions.disable")',
  'text: "Refresh"' => 'text: t("common.actions.refresh")',
  'text: "Close"' => 'text: t("common.actions.close")',
  'text: "Open"' => 'text: t("common.actions.open")',
  'text: "Select"' => 'text: t("common.actions.select")',
  'text: "Upload"' => 'text: t("common.actions.upload")',
  'text: "Download"' => 'text: t("common.actions.download")',
  'text: "Generate"' => 'text: t("common.actions.generate")',
  'text: "Use defaults"' => 'text: t("common.actions.use_defaults")',
  'text: "Re-apply"' => 'text: t("common.actions.reapply")',
  'text: "Reassign"' => 'text: t("common.actions.reassign")',
  'text: "Revert"' => 'text: t("common.actions.revert")',
  'text: "Revoke"' => 'text: t("common.actions.revoke")',
  'text: "Fix"' => 'text: t("common.actions.fix")',
  'text: "Today"' => 'text: t("common.actions.today")',
  'text: "All"' => 'text: t("common.actions.all")',
  'text: "None"' => 'text: t("common.actions.none")',
  'text: "Optional"' => 'text: t("common.actions.optional")',
  'text: "Required"' => 'text: t("common.actions.required")',
  
  # Labels
  'label: "Name"' => 'label: t("common.labels.name")',
  'label: "Description"' => 'label: t("common.labels.description")',
  'label: "Amount"' => 'label: t("common.labels.amount")',
  'label: "Date"' => 'label: t("common.labels.date")',
  'label: "Category"' => 'label: t("common.labels.category")',
  'label: "Account"' => 'label: t("common.labels.account")',
  'label: "Type"' => 'label: t("common.labels.type")',
  'label: "Status"' => 'label: t("common.labels.status")',
  'label: "Notes"' => 'label: t("common.labels.notes")',
  'label: "Tags"' => 'label: t("common.labels.tags")',
  'label: "Merchant"' => 'label: t("common.labels.merchant")',
  'label: "Currency"' => 'label: t("common.labels.currency")',
  'label: "Balance"' => 'label: t("common.labels.balance")',
  'label: "Value"' => 'label: t("common.labels.value")',
  'label: "Quantity"' => 'label: t("common.labels.quantity")',
  'label: "Price"' => 'label: t("common.labels.price")',
  'label: "Total"' => 'label: t("common.labels.total")',
  'label: "Percentage"' => 'label: t("common.labels.percentage")',
  'label: "Period"' => 'label: t("common.labels.period")',
  'label: "Start date"' => 'label: t("common.labels.start_date")',
  'label: "End date"' => 'label: t("common.labels.end_date")',
  'label: "Created at"' => 'label: t("common.labels.created_at")',
  'label: "Updated at"' => 'label: t("common.labels.updated_at")',
  'label: "Actions"' => 'label: t("common.labels.actions")',
  'label: "Details"' => 'label: t("common.labels.details")',
  'label: "Overview"' => 'label: t("common.labels.overview")',
  'label: "Settings"' => 'label: t("common.labels.settings")',
  'label: "History"' => 'label: t("common.labels.history")',
  'label: "Empty"' => 'label: t("common.labels.empty")',
  'label: "Loading"' => 'label: t("common.labels.loading")',
  'label: "Processing"' => 'label: t("common.labels.processing")',
  'label: "Completed"' => 'label: t("common.labels.completed")',
  'label: "Pending"' => 'label: t("common.labels.pending")',
  'label: "Failed"' => 'label: t("common.labels.failed")',
  'label: "Active"' => 'label: t("common.labels.active")',
  'label: "Inactive"' => 'label: t("common.labels.inactive")',
  'label: "Yes"' => 'label: t("common.labels.yes")',
  'label: "No"' => 'label: t("common.labels.no")',
  'label: "True"' => 'label: t("common.labels.true")',
  'label: "False"' => 'label: t("common.labels.false")',
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
