class Course < ApplicationRecord
  belongs_to :school
  belongs_to :faculty
  belongs_to :department
end
