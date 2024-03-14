class AddWarningMessagesToReportCardGenerators < ActiveRecord::Migration[7.1]
  def change
    add_column :report_card_generators, :warning_messages, :text, array: true, default: []
    add_column :report_card_generators, :process_duration, :float, default: 0.0
    add_column :report_card_generators, :least_performed_students, :text, array: true, default: []
  end
end
