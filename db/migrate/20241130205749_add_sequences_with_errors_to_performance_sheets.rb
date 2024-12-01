class AddSequencesWithErrorsToPerformanceSheets < ActiveRecord::Migration[7.1]
  def change
    add_column :performance_sheets, :sequences_with_issues, :text, array: true, default: []
    add_column :performance_sheets, :subjects_with_issues, :text, array: true, default: []
  end
end
