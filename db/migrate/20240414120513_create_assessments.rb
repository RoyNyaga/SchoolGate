class CreateAssessments < ActiveRecord::Migration[7.1]
  def change
    create_table :assessments do |t|
      t.references :school, null: false, foreign_key: true
      t.references :academic_year, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true
      t.references :semester, null: false, foreign_key: true
      t.integer :assessment_type, default: 1
      t.text :marks, array: true, default: []

      t.timestamps
    end
  end
end
