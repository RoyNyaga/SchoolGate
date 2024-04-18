class CreateReceipts < ActiveRecord::Migration[7.1]
  def change
    create_table :receipts do |t|
      t.references :school, null: false, foreign_key: true
      t.references :teacher, null: false, foreign_key: true
      t.references :academic_year, null: false, foreign_key: true
      t.references :student, null: false, foreign_key: true
      t.references :fee, null: false, foreign_key: true
      t.string :transaction_reference, null: false
      t.boolean :has_error, default: false

      t.timestamps
    end
    add_index :receipts, :transaction_reference
  end
end
