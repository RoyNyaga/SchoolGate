class Sequence < ApplicationRecord
  belongs_to :school
  belongs_to :school_class
  belongs_to :teacher
  belongs_to :subject
  belongs_to :term

  enum seq_num: { first_sequence: 1, second_sequence: 2, third_sequence: 3, forth_sequence: 4, fifth_sequence: 5, sith_sequence: 6 }

  def hashed_marks
    # parsing marks to ruby hash and converting the mark value to float
    self.marks.map { |m| eval(m) }.map { |a|
      { "id" => a["id"], "name" => a["name"], "mark" => a[
        "mark"].to_f }
    }
  end

  def sort_by_mark_desc
    hashed_marks.sort_by { |item| -item["mark"] }
  end
end
