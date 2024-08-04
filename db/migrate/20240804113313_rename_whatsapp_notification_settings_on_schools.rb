class RenameWhatsappNotificationSettingsOnSchools < ActiveRecord::Migration[7.1]
  def change
    rename_column :schools, :whatsapp_notification_settings, :phone_number
    change_column :schools, :phone_number, :string
  end
end
