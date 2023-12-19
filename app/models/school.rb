class School < ApplicationRecord
  belongs_to :teacher
  has_many :school_classes
end
