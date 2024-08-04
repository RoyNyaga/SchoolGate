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

  def self.send_fees_alert_message(receipt, school, school_admin_info, template_name)
    student = receipt.student
    super_admin_users_info.each do |user|
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
                    text: school.abbreviation,
                  },
                  {
                    type: "text",
                    text: student.full_name,
                  },
                  {
                    type: "text",
                    text: student.matricule,
                  },
                  {
                    type: "text",
                    text: number_to_currency(receipt.amount, unit: "", precision: 0),
                  },
                  {
                    type: "text",
                    text: receipt.readable_date(with_year: true),
                  },
                  {
                    type: "text",
                    text: receipt.update_history["updator"],
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
                    text: "#{receipt.id}?",
                  },
                ],
              },
            ],
          },
        }.to_json
      end
    end

    puts response.body
  end

  def self.send_super_admin_message(header, link_path, content, template_name, super_admin_users_info)
    link_path.slice!(0) if link_path.first == "/"
    content = Rails.env.production? ? content : "#{Rails.env}: " + content
    super_admin_users_info.each do |user|
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
                    text: header,
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
                    text: link_path,
                  },
                ],
              },
            ],
          },
        }.to_json
      end
    end
  end

  def self.send_school_administrator_message(school, school_admin_user_info, link_path, content, template_name)
    link_path.slice!(0) if link_path.first == "/"
    content = Rails.env.production? ? content : "#{Rails.env}: " + content
    school_admin_user_info.each do |user|
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
                    text: school.abbreviation,
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
                    text: link_path,
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
