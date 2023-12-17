class Worker < ApplicationRecord
  belongs_to :teacher
  belongs_to :school
end
