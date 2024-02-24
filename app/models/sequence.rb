class Sequence < ApplicationRecord
  belongs_to :school
  belongs_to :school_class
  belongs_to :teacher
  belongs_to :subject
  belongs_to :term

  delegate :academic_year, to: :term, prefix: true # prefix true means we will prefix the model name ex: sequence.term_academic_year
  delegate :term_type, to: :term
  enum seq_num: { first_sequence: 1, second_sequence: 2, third_sequence: 3, forth_sequence: 4, fifth_sequence: 5, sith_sequence: 6 }

  def hashed_marks
    # parsing marks to ruby hash and converting the mark value to float
    self.marks.map { |m| eval(m) }.map { |a|
      { "id" => a["id"], "name" => a["name"], "mark" => a[
        "mark"].to_f, "is_enrolled" => string_to_boolean(a["is_enrolled"]) }
    }
  end

  def string_to_boolean(str)
    str == "true"
  end

  def sort_by_mark_desc
    hashed_marks.sort_by { |item| -item["mark"] }
  end

  def seq_title
    "#{seq_num} - #{term_type} - #{term_academic_year}"
  end

  def enrolled_students
    hashed_marks.select { |student| student["is_enrolled"] == true }
  end

  def enrolled_num
    enrolled_students.count
  end

  def student_num_above_average
    enrolled_students.count { |student| student["mark"] >= 10 }
  end

  def highest_mark
    enrolled_students.max_by { |student| student["mark"] }["mark"]
  end

  def student_with_highest_mark # returns an array
    enrolled_students.select { |student| student["mark"] == highest_mark }
  end

  def percent_success
    ((student_num_above_average.to_f / enrolled_num.to_f) * 100).round(2)
  end
end
