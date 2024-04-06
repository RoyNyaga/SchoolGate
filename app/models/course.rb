class Course < ApplicationRecord
  belongs_to :school
  belongs_to :faculty
  belongs_to :department

  validates :name, presence: true
  validates :credit_value, presence: true
  validates :abbreviation, presence: true
  validates :code, presence: true

  def short_title
    abbreviation + code
  end

  def long_title
    name + " " + short_title
  end
end
