class School < ApplicationRecord
  belongs_to :teacher
  has_many :school_classes
  has_many :students
  has_many :subjects
end
