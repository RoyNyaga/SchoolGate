class AddNotificationWhatsappContactToSchools < ActiveRecord::Migration[7.1]
  def change
    add_column :schools, :whatsapp_notification_settings, :json, default: {}
  end
end
