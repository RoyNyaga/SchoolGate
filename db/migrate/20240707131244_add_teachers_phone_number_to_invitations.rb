class AddTeachersPhoneNumberToInvitations < ActiveRecord::Migration[7.1]
  def change
    add_column :invitations, :teachers_phone_number, :string, null: false, default: ""
  end
end
