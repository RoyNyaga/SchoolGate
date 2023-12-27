class Sequence < ApplicationRecord
  belongs_to :school
  belongs_to :school_class
  belongs_to :teacher
  belongs_to :subject

  enum seq_num: { first_sequence: 1, second_sequence: 2, third_sequence: 3, forth_sequence: 4, fifth_sequence: 5, sith_sequence: 6 }

  def hashed_marks
    self.marks.map { |m| eval(m) }
  end

  def title
    "#{seq_num.humanize} #{academic_year_start} / #{academic_year_end}"
  end
end
