class Student < ApplicationRecord
  belongs_to :school
  belongs_to :school_class

  def sequence_mark_per_subject(marks)
    marks.find { |student| student["id"] == id.to_s }["mark"]
  end

  def rank_per_subject(marks)
    all_marks = marks.map { |mark| mark["mark"] }.uniq
    sequence_mark = sequence_mark_per_subject(marks)
    all_marks.index(sequence_mark) + 1
  end
end
