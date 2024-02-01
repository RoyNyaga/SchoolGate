class AddMoreFieldsToTeachers < ActiveRecord::Migration[7.1]
  def change
    add_column :teachers, :first_name, :string
    add_column :teachers, :last_name, :string
    add_column :teachers, :town, :string
    rename_column :teachers, :name, :full_name
  end
end
