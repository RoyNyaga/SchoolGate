class PageVisit < ApplicationRecord
  def self.generate_key(controller_name, action_name)
    "#{controller_name}_#{action_name}"
  end
end
