class Course < ApplicationRecord
  belongs_to :school
  belongs_to :faculty
  belongs_to :department

  validates :name, presence: true
  validates :credit_value, presence: true
  validates :abbreviation, presence: true
  validates :code, presence: true
end
