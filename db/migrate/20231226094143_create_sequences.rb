class CreateSequences < ActiveRecord::Migration[7.1]
  def change
    create_table :sequences do |t|
      t.references :school, null: false, foreign_key: true
      t.references :school_class, null: false, foreign_key: true
      t.references :teacher, null: false, foreign_key: true
      t.integer :type, null: false
      t.string :academic_year_start, null: false
      t.string :academic_year_end, null: false

      t.timestamps
    end
  end
end
