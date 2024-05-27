class TeacherQue < ApplicationRecord
  cattr_accessor :education_levels
  validates :online_report_cards, presence: true

  self.education_levels = ["basic education", "secondary education", "higher education"]
  store_accessor :referal, :referal_school_name, :referal_location, :referal_proprietors_name, :referal_proprietors_contact
end
