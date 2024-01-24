class CreateFees < ActiveRecord::Migration[7.1]
  def change
    create_table :fees do |t|
      t.references :school, null: false, foreign_key: true
      t.references :school_class, null: false, foreign_key: true
      t.references :student, null: false, foreign_key: true
      t.text :updator_ids, array: true, default: []
      t.string :academic_year, null: false
      t.text :installments, array: true, default: []
      t.integer :installment_num, default: 0
      t.integer :total_fee_paid, default: 0
      t.boolean :is_completed, default: false

      t.timestamps
    end
  end
end
