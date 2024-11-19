class CreateDeposits < ActiveRecord::Migration[7.1]
  def change
    create_table :deposits do |t|
      t.references :school, null: false, foreign_key: true
      t.references :teacher, null: false, foreign_key: true
      t.references :academic_year, null: false, foreign_key: true
      t.integer :origin, default: 0
      t.integer :approval, default: 0
      t.float :amount, null: false
      t.string :description

      t.timestamps
    end
  end
end
