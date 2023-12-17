class CreateWorkers < ActiveRecord::Migration[7.1]
  def change
    create_table :workers do |t|
      t.references :teacher, null: false, foreign_key: true
      t.references :school, null: false, foreign_key: true
      t.integer :permission
      t.float :monthly_rate

      t.timestamps
    end
  end
end
