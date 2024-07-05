class WhatsappNotificationJob < ApplicationJob
  queue_as :report_card_processor

  def perform(object_id, template_name)
    if template_name == "fees_instant_pay_template"
      WhatsappNotificationService.send_fees_alert_message(object_id, template_name) #object_id here is the receipt_id
    end
  end
end
