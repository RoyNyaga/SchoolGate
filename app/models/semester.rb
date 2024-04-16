class Semester < ApplicationRecord
  belongs_to :school
  belongs_to :academic_year

  enum semester_type: { first_semester: 1, second_semester: 2, resit_semester: 3 }

  scope :active, -> { where(is_active: true) }
end
