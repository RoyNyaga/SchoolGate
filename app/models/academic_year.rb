class AcademicYear < ApplicationRecord
  belongs_to :school
  has_many :terms
  has_many :report_cards

  validates :year, presence: true, uniqueness: true

  scope :active, -> { where(is_active: true) }
end
