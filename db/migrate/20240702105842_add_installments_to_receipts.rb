class AddInstallmentsToReceipts < ActiveRecord::Migration[7.1]
  def change
    add_column :receipts, :total_fees_paid_at_this_point, :float, default: 0.0
    add_column :receipts, :installment_num, :integer, default: 0
  end
end
