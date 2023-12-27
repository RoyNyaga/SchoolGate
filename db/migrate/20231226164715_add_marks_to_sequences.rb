class AddMarksToSequences < ActiveRecord::Migration[7.1]
  def change
    add_column :sequences, :marks, :text, array: true, default: []
    add_reference :sequences, :subject, null: false, foreign_key: true
  end
end
