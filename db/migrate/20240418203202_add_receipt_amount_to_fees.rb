class AddReceiptAmountToFees < ActiveRecord::Migration[7.1]
  def change
    add_column :fees, :receipt_amount, :float
    add_column :fees, :is_receipt_and_fee_amount_in_phase, :boolean, default: true
  end
end
