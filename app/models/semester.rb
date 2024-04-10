class Semester < ApplicationRecord
  belongs_to :school
  belongs_to :academic_year

  enum term_type: { first: 1, second: 2, resit: 3 }
end
