class Lecturing < ApplicationRecord
  belongs_to :course
  belongs_to :teacher
end
