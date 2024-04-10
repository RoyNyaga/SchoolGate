class AddCompleteNameToCourses < ActiveRecord::Migration[7.1]
  def change
    add_column :courses, :complete_name, :string
  end
end
