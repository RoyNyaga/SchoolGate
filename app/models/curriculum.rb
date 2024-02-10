class Curriculum < ApplicationRecord
  belongs_to :school
  belongs_to :school_class
  belongs_to :teacher
  belongs_to :subject
end
