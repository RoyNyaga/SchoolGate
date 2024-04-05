class Department < ApplicationRecord
  belongs_to :school
  belongs_to :faculty

  validates :name, presence: true
end
