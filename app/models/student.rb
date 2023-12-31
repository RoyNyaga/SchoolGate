class Student < ApplicationRecord
  belongs_to :school
  belongs_to :school_class
  has_many :report_cards

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
end
