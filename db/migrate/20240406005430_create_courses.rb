class CreateCourses < ActiveRecord::Migration[7.1]
  def change
    create_table :courses do |t|
      t.references :school, null: false, foreign_key: true
      t.references :faculty, null: false, foreign_key: true
      t.references :department, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :credit_value, null: false

      t.timestamps
    end
  end
end
