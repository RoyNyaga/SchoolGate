class SuperAdminWhatsappJob < ApplicationJob
  queue_as :report_card_processor

  def perform(header, link_path, content, template_name) # permission can be an array of permissions for multiple permissions or single string
    if template_name == "super_admin_notification_template"
      super_admin_users_info = AdminUser.parse_users_info #[{:name=>"Ade George", :phone_number=>"000000001"}, {:name=>"Nyaga Andre", :phone_number=>"237671172775"}]
      WhatsappNotificationService.send_super_admin_message(header, link_path, content, template_name, super_admin_users_info)
    end
  end
end
