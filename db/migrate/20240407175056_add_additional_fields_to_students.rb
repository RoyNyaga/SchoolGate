class AddAdditionalFieldsToStudents < ActiveRecord::Migration[7.1]
  def change
    add_column :students, :education_level, :integer, default: 2
    add_column :students, :faculty_id, :integer
    add_column :students, :department_id, :integer
  end
end
