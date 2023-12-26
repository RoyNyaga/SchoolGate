class AddMarksToSequences < ActiveRecord::Migration[7.1]
  def change
    add_column :sequences, :marks, :text, array: true, default: []
  end
end
