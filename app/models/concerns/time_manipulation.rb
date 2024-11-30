# app/models/concerns/time_manipulation.rb
module TimeManipulation
  extend ActiveSupport::Concern

  included do
    def readable_date(date: nil, with_year: false, with_time: false)
      format = with_year ? "%a %b %d, %Y" : "%a %b %d"
      date ||= created_at
      readable_date = with_time ? "#{date.strftime(format)} - #{date.strftime("%l:%M%P").strip.downcase}" : date.strftime(format)
    end

    def ddmmyy_format(date: nil)
      date || created_at
      date.strftime("%d/%m/%Y")
    end
  end

  class_methods do
    def generate_start_and_end_week_dates(date)
      start_of_week = date.beginning_of_week
      end_of_week = date.end_of_week
      { start: start_of_week, end: end_of_week }
    end

    def generate_time_stamp
      Time.now.to_i.to_s
    end
  end
end
