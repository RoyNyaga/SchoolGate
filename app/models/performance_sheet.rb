class PerformanceSheet < ApplicationRecord
  belongs_to :school
  belongs_to :academic_year
  belongs_to :teacher
  belongs_to :school_class
  belongs_to :term
end
