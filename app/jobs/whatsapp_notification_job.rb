class WhatsappNotificationJob < ApplicationJob
  queue_as :report_card_processor

  def perform(object_id, template_name, class_name)
    if template_name == "fees_instant_pay_template"
      WhatsappNotificationService.send_fees_alert_message(object_id, template_name) #object_id here is the receipt_id
    elsif template_name == "general_update_template"
      users_info = AdminUser.parse_users_info
      if class_name == "PageVisit"
        page_visit = PageVisit.find_by(id: object_id)
        content = page_visit.admin_content_notification_message
        WhatsappNotificationService.send_admin_message(content, template_name, users_info, class_name)
      elsif class_name == "School"
        school = School.find_by(id: object_id)
        content = school.admin_content_notification_message
        WhatsappNotificationService.send_admin_message(content, template_name, users_info, class_name)
      elsif class_name = "Teacher"
        teacher = Teacher.find_by(id: object_id)
        content = teacher.admin_content_notification_message
        WhatsappNotificationService.send_admin_message(content, template_name, users_info, class_name)
      end
    end
  end
end
