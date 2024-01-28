class AddFieldsToStudents < ActiveRecord::Migration[7.1]
  def change
    add_column :students, :location, :string
    add_column :students, :unique_identification, :string
    add_column :students, :portal_code, :string
    add_column :students, :first_name, :string
    add_column :students, :last_name, :string
    add_column :students, :previous_classes, :text, array: true, default: []
  end
end
