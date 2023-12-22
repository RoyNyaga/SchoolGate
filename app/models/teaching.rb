class Teaching < ApplicationRecord
  belongs_to :teacher
  belongs_to :subject
  belongs_to :school_class
end
