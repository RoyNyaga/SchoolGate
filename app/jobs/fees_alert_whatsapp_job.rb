class FeesAlertWhatsappJob < ApplicationJob
  queue_as :report_card_processor

  def perform(receipt_id, permissions, template_name)
    receipt = Receipt.find_by(id: receipt_id)
    school = receipt.school
    school_admin_user_info = school.administrators(permissions).map { |teacher| { name: teacher.full_name, phone_number: teacher.phone_number } }
    if template_name == "fees_instant_pay_template"
      WhatsappNotificationService.send_fees_alert_message(receipt, school, school_admin_user_info, template_name) #object_id here is the receipt_id
    end
  end
end
