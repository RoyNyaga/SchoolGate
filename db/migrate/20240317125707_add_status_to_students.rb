class AddStatusToStudents < ActiveRecord::Migration[7.1]
  def change
    add_column :students, :status, :integer, default: 0
  end
end
