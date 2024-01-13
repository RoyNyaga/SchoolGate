class RenameUpdatorIdOnFees < ActiveRecord::Migration[7.1]
  def change
    rename_column :fees, :updator_ids, :update_records
  end
end
