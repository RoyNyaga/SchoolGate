class CreateWorkers < ActiveRecord::Migration[7.1]
  def change
    create_table :workers do |t|
      t.references :school, null: false, foreign_key: true
      t.references :teacher, null: false, foreign_key: true
      t.integer :permission, default: 0
      t.float :agreed_salary, default: 0
      t.string :job_description
      t.integer :status

      t.timestamps
    end
  end
end
