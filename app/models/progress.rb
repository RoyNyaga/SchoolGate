class Progress < ApplicationRecord
  belongs_to :school
  belongs_to :subject
  belongs_to :teacher
  belongs_to :term
end
