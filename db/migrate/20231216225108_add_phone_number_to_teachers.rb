class AddPhoneNumberToTeachers < ActiveRecord::Migration[7.1]
  def change
    add_column :teachers, :phone_number, :string, null: false
    add_index :teachers, :phone_number, unique: true
  end
end
