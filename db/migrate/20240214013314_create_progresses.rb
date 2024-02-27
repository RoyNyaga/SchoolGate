class CreateProgresses < ActiveRecord::Migration[7.1]
  def change
    create_table :progresses do |t|
      t.references :school, null: false, foreign_key: true
      t.references :subject, null: false, foreign_key: true
      t.references :teacher, null: false, foreign_key: true
      t.references :term, null: false, foreign_key: true
      t.text :topics, array: true, default: []
      t.time :duration
      t.text :absent_students, array: true, default: []
      t.string :academic_year, null: false
      t.integer :seq_num, null: false

      t.timestamps
    end
  end
end
