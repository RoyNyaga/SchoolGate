class AddPercentageCompletToFees < ActiveRecord::Migration[7.1]
  def change
    add_column :fees, :percentage_complete, :float, default: 0.00, precision: 5, scale: 2
  end
end
