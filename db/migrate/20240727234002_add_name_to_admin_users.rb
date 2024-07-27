class AddNameToAdminUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :admin_users, :name, :string, null: false, default: "Admin"
  end
end
