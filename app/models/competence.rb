class Competence < ApplicationRecord
  belongs_to :school
  belongs_to :school_class
  belongs_to :subject
end
