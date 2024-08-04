class SchoolAdminWhatsappJob < ApplicationJob
  queue_as :report_card_processor

  def perform(school_id, permissions, link_path, content, template_name) # permission can be an array of permissions for multiple permissions or single string
    school = School.find_by(id: school_id)
    school_admin_user_info = school.administrators(permissions).map { |teacher| { name: teacher.full_name, phone_number: teacher.phone_number } }
    if template_name == "administrator_notification_template"
      WhatsappNotificationService.send_school_administrator_message(school, school_admin_user_info, link_path, content, template_name)
    end
  end
end
