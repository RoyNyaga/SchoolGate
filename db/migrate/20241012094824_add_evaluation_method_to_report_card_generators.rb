class AddEvaluationMethodToReportCardGenerators < ActiveRecord::Migration[7.1]
  def change
    add_column :report_card_generators, :evaluation_method, :integer, default: 0
  end
end
