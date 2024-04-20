class AddAmountReceipts < ActiveRecord::Migration[7.1]
  def change
    add_column :receipts, :amount, :float
  end
end
