class CreateCourseResults < ActiveRecord::Migration[7.1]
  def change
    create_table :course_results do |t|
      t.references :school, null: false, foreign_key: true
      t.references :student, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true
      t.references :academic_year, null: false, foreign_key: true
      t.references :semester, null: false, foreign_key: true
      t.float :ca_mark, default: 0.0
      t.float :exam_mark, default: 0.0
      t.float :resit_mark, default: 0.0
      t.float :total_mark, default: 0.0
      t.boolean :has_resit, default: false
      t.boolean :is_validated, default: false
      t.integer :credit_val

      t.timestamps
    end
  end
end
