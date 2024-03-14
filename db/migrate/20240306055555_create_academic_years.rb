class CreateAcademicYears < ActiveRecord::Migration[7.1]
  def change
    create_table :academic_years do |t|
      t.references :school, null: false, foreign_key: true
      t.string :year
      t.boolean :is_active

      t.timestamps
    end
  end
end
