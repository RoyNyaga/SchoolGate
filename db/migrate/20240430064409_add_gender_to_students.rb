class AddGenderToStudents < ActiveRecord::Migration[7.1]
  def change
    add_column :students, :gender, :integer, null: false, default: 0
  end
end
