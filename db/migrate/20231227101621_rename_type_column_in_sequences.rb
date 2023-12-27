class RenameTypeColumnInSequences < ActiveRecord::Migration[7.1]
  def change
    rename_column :sequences, :type, :seq_num
  end
end
