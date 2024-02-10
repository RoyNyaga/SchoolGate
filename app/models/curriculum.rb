class Curriculum < ApplicationRecord
  include TimeManipulation

  belongs_to :school
  belongs_to :school_class
  belongs_to :teacher
  belongs_to :subject

  validates :title, presence: true
end
