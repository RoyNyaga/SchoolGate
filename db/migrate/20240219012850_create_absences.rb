class CreateAbsences < ActiveRecord::Migration[7.1]
  def change
    create_table :absences do |t|
      t.references :school, null: false, foreign_key: true
      t.references :student, null: false, foreign_key: true
      t.references :progress, null: false, foreign_key: true
      t.references :term, null: false, foreign_key: true
      t.string :academic_year

      t.timestamps
    end
  end
end
