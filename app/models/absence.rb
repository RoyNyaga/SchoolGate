class Absence < ApplicationRecord
  belongs_to :school
  belongs_to :student
  belongs_to :progress
  belongs_to :term
end
