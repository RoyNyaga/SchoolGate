class AddEvaluationMethodToSequences < ActiveRecord::Migration[7.1]
  def change
    add_column :sequences, :evaluation_method, :integer, default: 0
  end
end
