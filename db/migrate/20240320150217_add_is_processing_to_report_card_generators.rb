class AddIsProcessingToReportCardGenerators < ActiveRecord::Migration[7.1]
  def change
    add_column :report_card_generators, :is_processing, :boolean, default: false
  end
end
