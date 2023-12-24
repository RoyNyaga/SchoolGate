class AddNameToTeachers < ActiveRecord::Migration[7.1]
  def change
    add_column :teachers, :name, :string, null: false, default: ""
  end
end
