class PerformanceSheet < ApplicationRecord
  has_one_attached :sheet

  belongs_to :school
  belongs_to :academic_year
  belongs_to :teacher
  belongs_to :school_class
  belongs_to :term
end
