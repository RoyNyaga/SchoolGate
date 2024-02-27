class Subject < ApplicationRecord
  belongs_to :school
  belongs_to :school_class
  has_many :teachings, dependent: :destroy
  has_many :teachers, through: :teachings, source: "teacher"
  has_many :sequences, dependent: :destroy
  has_many :topics, dependent: :destroy

  def total_on_marks
    20 * coefficient
  end
end
