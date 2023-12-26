class AddNameToTeachers < ActiveRecord::Migration[7.1]
  def change
    add_column :teachers, :name, :string, null: false, default: ""
    add_reference :teachers, :subject, null: false, foreign_key: true
  end
end
