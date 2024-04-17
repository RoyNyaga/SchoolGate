class AddCourseRegistrationToCourseResults < ActiveRecord::Migration[7.1]
  def change
    add_reference :course_results, :course_registration, null: true, foreign_key: true
  end
end
