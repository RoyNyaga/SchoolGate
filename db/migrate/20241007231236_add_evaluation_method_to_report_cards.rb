class AddEvaluationMethodToReportCards < ActiveRecord::Migration[7.1]
  def change
    add_column :report_cards, :evaluation_method, :integer, default: 0
  end
end
