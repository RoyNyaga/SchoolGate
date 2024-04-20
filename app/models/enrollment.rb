class Enrollment < ApplicationRecord
  belongs_to :school
  belongs_to :student
  belongs_to :course
  belongs_to :academic_year
  belongs_to :semester

  def title
    "#{semester.semester_type.humanize} / #{academic_year.year}"
  end
end
