class Term < ApplicationRecord
  belongs_to :school
  has_many :sequences
end
