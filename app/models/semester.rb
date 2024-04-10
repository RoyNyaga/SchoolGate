class Semester < ApplicationRecord
  belongs_to :school
  belongs_to :academic_year

  enum type: { first_semester: 1, second_semester: 2, resit_semester: 3 }
end
