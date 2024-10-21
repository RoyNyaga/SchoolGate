class Subject < ApplicationRecord
  belongs_to :school
  belongs_to :school_class
  has_many :teachings, dependent: :destroy
  has_many :teachers, through: :teachings, source: "teacher"
  has_many :sequences
  has_many :progresses
  has_many :curriculums
  has_many :topics
  has_many :competences, dependent: :destroy

  store_accessor :remarks, :less_than_equal_to_5, :less_than_equal_to_9, :less_than_equal_to_12,
                 :less_than_equal_to_15, :less_than_equal_to_18, :less_than_equal_to_20
  validates :coefficient, presence: true
  validates :name, presence: true

  def total_on_marks
    20 * coefficient
  end

  def add_remarks(average)
    case average
    when (0..5)
      less_than_equal_to_5
    when (6..9)
      less_than_equal_to_9
    when (10..12)
      less_than_equal_to_12
    when (13..15)
      less_than_equal_to_15
    when (16..18)
      less_than_equal_to_18
    when (19..20)
      less_than_equal_to_20
    else
      "Out of range"
    end
  end

  def title
    "#{name} - #{school_class.name}"
  end
end
