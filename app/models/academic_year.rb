class AcademicYear < ApplicationRecord
  belongs_to :school
  has_many :terms
  has_many :report_cards
  has_many :semesters
  has_many :fees

  validates :year, presence: true, uniqueness: { scope: :school_id,
                                                 message: "Academic already exist for this school" }

  scope :active, -> { where(is_active: true) }
end
