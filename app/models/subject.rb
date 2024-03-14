class Subject < ApplicationRecord
  belongs_to :school
  belongs_to :school_class
  has_many :teachings, dependent: :destroy
  has_many :teachers, through: :teachings, source: "teacher"
  has_many :sequences, dependent: :destroy
  has_many :topics, dependent: :destroy

  store_accessor :remarks, :less_than_equal_to_5, :less_than_equal_to_9, :less_than_equal_to_12,
                 :less_than_equal_to_15, :less_than_equal_to_18, :less_than_equal_to_20

  def total_on_marks
    20 * coefficient
  end

  def add_remarks(average)
    case average
    when average <= 5
      less_than_equal_to_5
    when average <= 9
      less_than_equal_to_9
    when average <= 12
      less_than_equal_to_12
    when average <= less_than_equal_to_15
      less_than_equal_to_15
    when average <= less_than_equal_to_18
      less_than_equal_to_18
    when average <= less_than_equal_to_20
      less_than_equal_to_20
    end
  end
end
