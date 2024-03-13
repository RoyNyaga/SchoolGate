class AddStatusToSequences < ActiveRecord::Migration[7.1]
  def change
    add_column :sequences, :status, :integer, default: 0
  end
end
