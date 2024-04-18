class AddUpdateHistroyToReceipts < ActiveRecord::Migration[7.1]
  def change
    add_column :receipts, :update_history, :json, default: {}
  end
end
