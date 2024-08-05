class AddIsRegisteredToStudents < ActiveRecord::Migration[7.1]
  def change
    add_column :students, :is_registered, :boolean, default: false
  end
end
