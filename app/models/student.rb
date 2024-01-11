class Student < ApplicationRecord
  belongs_to :school
  belongs_to :school_class
  has_many :report_cards
  has_many :fees, dependent: :destroy

  before_save :create_fees

  def sequence_mark_per_subject(marks)
    marks.find { |student| student["id"] == id.to_s }["mark"]
  end

  def rank_per_subject(marks)
    all_marks = marks.map { |mark| mark["mark"] }.uniq
    sequence_mark = sequence_mark_per_subject(marks)
    all_marks.index(sequence_mark) + 1
  end

  def sequence_rank(sequence_averages)
    mark = sequence_mark_per_subject(sequence_averages)
    arr = sequence_averages.map { |mark| mark["mark"] }.uniq.sort.reverse
    arr.index(mark) + 1
  end

  def create_fees
    fees.create(school_id: school_id, school_class_id: school_class_id)
  end
end
