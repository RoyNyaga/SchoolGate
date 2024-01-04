class AddTotalScoreToReportCards < ActiveRecord::Migration[7.1]
  def change
    add_column :report_cards, :total_score, :float, default: 0.0
    add_column :report_cards, :total_coefficient, :float, default: 0.0
  end
end
