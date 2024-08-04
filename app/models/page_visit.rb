class PageVisit < ApplicationRecord
  before_update :set_total_visit_count

  def self.generate_key(controller_name, action_name)
    "#{controller_name}_#{action_name}"
  end

  def stringify_page_visits
    pages.map { |key, value| "#{key}: #{value}" }.join(", ")
  end

  def admin_content_notification_message
    "The following updates have been made on page visits #{stringify_page_visits}. Total_visit_count: #{total_visit_count}"
  end

  private

  def set_total_visit_count
    self.total_visit_count = pages.values.sum
  end
end
