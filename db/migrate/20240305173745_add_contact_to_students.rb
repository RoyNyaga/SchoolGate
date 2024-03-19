class AddContactToStudents < ActiveRecord::Migration[7.1]
  def change
    add_column :students, :contact, :string
  end
end
