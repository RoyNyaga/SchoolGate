class Course < ApplicationRecord
  belongs_to :school
  belongs_to :faculty
  belongs_to :department
  has_many :lecturings, dependent: :destroy
  has_many :lecturers, through: :lecturings, source: "teacher"
  has_many :enrollments, dependent: :destroy
  has_many :course_results
  has_many :assessments

  validates :name, presence: true
  validates :credit_value, presence: true
  validates :abbreviation, presence: true
  validates :code, presence: true

  before_save :set_complete_name

  def short_title
    abbreviation + "-" + code
  end

  def long_title
    name + " " + short_title
  end

  private

  def set_complete_name
    self.complete_name = long_title.downcase
  end
end
