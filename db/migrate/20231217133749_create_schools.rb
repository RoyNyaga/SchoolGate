class CreateSchools < ActiveRecord::Migration[7.1]
  def change
    create_table :schools do |t|
      t.references :teacher, null: false, foreign_key: true
      t.string :full_name, null: false
      t.string :abbreviation
      t.string :town
      t.string :address
      t.string :moto

      t.timestamps
    end
  end
end
