class AddTeacherToAssessments < ActiveRecord::Migration[7.1]
  def change
    add_reference :assessments, :teacher, null: false, foreign_key: true
  end
end
