class AcademicYear < ApplicationRecord
  belongs_to :school
  has_many :terms
  has_many :report_cards

  validates :year, presence: true, uniqueness: { scope: :school_id,
                                         message: "Academic already exist for this school" }

  scope :active, -> { where(is_active: true) }
end
