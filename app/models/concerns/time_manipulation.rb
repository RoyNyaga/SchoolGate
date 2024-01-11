# app/models/concerns/time_manipulation.rb
module TimeManipulation
  extend ActiveSupport::Concern

  included do
    def generate_current_academic_year
      current_date = Date.today
      start_year = current_date.month >= 8 ? current_date.year : current_date.year - 1
      end_year = start_year + 1

      "#{start_year}-#{end_year}"
    end
  end

  class_methods do
  end
end
