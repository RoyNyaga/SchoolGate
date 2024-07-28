include ActionView::Helpers::NumberHelper

class WhatsappNotificationService
  WHATSAPP_API_URL = ENV["WHATSAPP_API_BASE_URL"]
  ACCESS_TOKEN = ENV["WHATSAPP_NOTIFICATION_ACCESS_TOKEN"]

  def self.conn
    @conn ||= Faraday.new(url: WHATSAPP_API_URL) do |faraday|
      faraday.request :json
      faraday.response :logger
      faraday.adapter Faraday.default_adapter
    end
  end

  def self.send_fees_alert_message(receipt_id, template_name)
    @receipt = Receipt.find(receipt_id)
    @school = @receipt.school
    @student = @receipt.student

    response = conn.post do |req|
      req.headers["Authorization"] = "Bearer #{ACCESS_TOKEN}"
      req.headers["Content-Type"] = "application/json"
      req.body = {
        messaging_product: "whatsapp",
        to: @school.notification_contact,
        type: "template",
        template: {
          name: template_name,
          language: { code: "en_US" },
          components: [
            {
              type: "body",
              parameters: [
                {
                  type: "text",
                  text: @school.abbreviation,
                },
                {
                  type: "text",
                  text: @student.full_name,
                },
                {
                  type: "text",
                  text: @student.matricule,
                },
                {
                  type: "text",
                  text: number_to_currency(@receipt.amount, unit: "", precision: 0),
                },
                {
                  type: "text",
                  text: @receipt.readable_date(with_year: true),
                },
                {
                  type: "text",
                  text: @receipt.update_history["updator"],
                },
              ],
            },
            {
              type: "button",
              sub_type: "url",
              index: "0",
              parameters: [
                {
                  type: "text",
                  text: "#{@receipt.id}",
                },
              ],
            },
          ],
        },
      }.to_json
    end

    puts response.body
  end

  def self.send_admin_message(content, template_name, users_info, class_name)
    content = Rails.env.production? ? content : "#{Rails.env}: " + content
    users_info.each do |user|
      response = conn.post do |req|
        req.headers["Authorization"] = "Bearer #{ACCESS_TOKEN}"
        req.headers["Content-Type"] = "application/json"
        req.body = {
          messaging_product: "whatsapp",
          to: user[:phone_number],
          type: "template",
          template: {
            name: template_name,
            language: { code: "en_US" },
            components: [
              {
                type: "body",
                parameters: [
                  {
                    type: "text",
                    text: user[:name],
                  },
                  {
                    type: "text",
                    text: content,
                  },
                ],
              },
              {
                type: "header",
                parameters: [
                  {
                    type: "text",
                    text: class_name,
                  },
                ],
              },
            ],
          },
        }.to_json
      end
    end
  end
end
