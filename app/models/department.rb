class Department < ApplicationRecord
  belongs_to :school
  belongs_to :faculty
  has_many :courses

  validates :name, presence: true
end
