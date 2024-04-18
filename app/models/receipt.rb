class Receipt < ApplicationRecord
  belongs_to :school
  belongs_to :teacher
  belongs_to :academic_year
  belongs_to :student
  belongs_to :fee
end
