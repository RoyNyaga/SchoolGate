class AddCourseNameToAssessments < ActiveRecord::Migration[7.1]
  def change
    add_column :assessments, :course_name, :string
  end
end
