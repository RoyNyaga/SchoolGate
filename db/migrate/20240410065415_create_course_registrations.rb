class CreateCourseRegistrations < ActiveRecord::Migration[7.1]
  def change
    create_table :course_registrations do |t|
      t.references :school, null: false, foreign_key: true
      t.references :student, null: false, foreign_key: true
      t.references :academic_year, null: false, foreign_key: true
      t.references :semester, null: false, foreign_key: true
      t.string :credit_val
      t.text :courses, array: true, default: []

      t.timestamps
    end
  end
end
