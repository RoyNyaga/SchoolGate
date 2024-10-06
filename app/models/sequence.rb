class Sequence < ApplicationRecord
  belongs_to :school
  belongs_to :school_class
  belongs_to :teacher
  belongs_to :subject
  belongs_to :term
  belongs_to :academic_year

  delegate :term_type, to: :term
  delegate :name, to: :school_class

  enum seq_num: { first_sequence: 1, second_sequence: 2, third_sequence: 3, forth_sequence: 4,
                  fifth_sequence: 5, sith_sequence: 6, first_term_sequence: 7, second_term_sequence: 8, third_term_sequence: 9 }
  enum status: { in_progress: 0, submitted: 1, rejected: 2, approved: 3 }
  enum evaluation_method: { first_and_second_sequence_evaluation_method: 0, single_competence_based_evaluation_method: 1 }

  # validate :sequences_per_term
  validate :enrollment_num_not_zero

  def self.allowed_seq_nums(school_class)
    if school_class.should_evaluate_multiple_competences_per_subject
      # Return only keys containing "term" if multiple competences should be evaluated
      seq_nums.select { |key, _| key.include?("term") }
    else
      # Exclude keys containing "term" if multiple competences should not be evaluated
      seq_nums.reject { |key, _| key.include?("term") }
    end
  end

  def self.determine_evaluation_method(school_class)
    school_class.should_evaluate_multiple_competences_per_subject ? 1 : 0
  end

  def hashed_marks
    # parsing marks to ruby hash and converting the mark value to float
    self.marks.map { |m| eval(m) }.map { |a|
      { "id" => a["id"].to_i, "name" => a["name"], "mark" => a[
        "mark"].to_f, "is_enrolled" => string_to_boolean(a["is_enrolled"]) }
    }
  end

  def string_to_boolean(str)
    str == "true"
  end

  def sort_by_mark_desc
    enrolled_students.sort_by { |item| -item["mark"] }
  end

  def seq_title(with_class_name: false)
    with_class_name ? "#{name} - #{seq_num} - #{term_type} - #{academic_year.year}" :
      "#{seq_num} - #{term_type} - #{academic_year.year}"
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

  private

  # def sequences_per_term
  #   unless self.persisted?
  #     errors.add(:term, "Can not have more than 2 sequences per term") if term.sequences.count == 2
  #   end
  # end

  def enrollment_num_not_zero
    errors.add(:enrollment, "should exist atleast for one student") if enrolled_students.size == 0
  end
end
