class Assessment < ApplicationRecord
  belongs_to :school
  belongs_to :academic_year
  belongs_to :course
  belongs_to :semester
end
