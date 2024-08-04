class RenameWhatsappNotificationSettingsOnSchools < ActiveRecord::Migration[7.1]
  def change
    rename_column :schools, :whatsapp_notification_settings, :contacts
  end
end
