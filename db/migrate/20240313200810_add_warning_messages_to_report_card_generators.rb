class AddWarningMessagesToReportCardGenerators < ActiveRecord::Migration[7.1]
  def change
    add_column :report_card_generators, :warning_messages, :text, array: true, default: []
  end
end
