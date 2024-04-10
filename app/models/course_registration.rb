class CourseRegistration < ApplicationRecord
  belongs_to :school
  belongs_to :student
  belongs_to :academic_year
  belongs_to :semester
end
