class Sequence < ApplicationRecord
  include DataTrans
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
  # validate :enrollment_num_not_zero

  before_save do
    update_marks_with_total
  end

  before_create do
    set_evaluation_method
  end

  def self.allowed_seq_nums(school_class)
    if school_class.should_evaluate_multiple_competences_per_subject
      # Return only keys containing "term" if multiple competences should be evaluated
      seq_nums.select { |key, _| key.include?("term") }
    else
      # Exclude keys containing "term" if multiple competences should not be evaluated
      seq_nums.reject { |key, _| key.include?("term") }
    end
  end

  def hashed_marks
    if first_and_second_sequence_evaluation_method?
      # parsing marks to ruby hash and converting the mark value to float
      Sequence.string_to_hash_arr(marks).map { |student|
        { "id" => student["id"].to_i, "name" => student["name"], "mark" => student[
          "mark"].to_f, "is_enrolled" => ActiveRecord::Type::Boolean.new.cast(student["is_enrolled"]) }
      }
    else
      Sequence.string_to_hash_arr(marks).map do |student|
        {
          "id" => student["id"].to_i,
          "name" => student["name"],
          "is_enrolled" => ActiveRecord::Type::Boolean.new.cast(student["is_enrolled"]), # Convert to boolean
          "mark" => student["mark"].to_f,
          "competences" => student["competences"].map do |competence|
            {
              "id" => competence["id"].to_i,
              "title" => competence["title"],
              "mark" => competence["mark"].to_f, # Convert to float
            }
          end,
        }
      end
    end
  end

  def enrolled_students
    hashed_marks.select { |student| student["is_enrolled"] == true }
  end

  def sort_by_mark_desc(is_competence_based: false, competence_id: nil)
    if single_competence_based_evaluation_method? && is_competence_based
      get_competence_data(competence_id).sort_by { |student| -student["competence"]["mark"] }
    else
      enrolled_students.sort_by { |item| -item["mark"] }
    end
  end

  def seq_title(with_class_name: false)
    with_class_name ? "#{name} - #{seq_num} - #{term_type} - #{academic_year.year}" :
      "#{seq_num} - #{term_type} - #{academic_year.year}"
  end

  def enrolled_num
    enrolled_students.count
  end

  def student_num_above_average(is_competence_based: false, competence_id: nil)
    if single_competence_based_evaluation_method? && is_competence_based
      get_competence_data(competence_id).count { |student| student["competence"]["mark"] >= 10 }
    else
      enrolled_students.count { |student| student["mark"] >= 10 }
    end
  end

  def highest_mark(is_competence_based: false, competence_id: nil)
    if single_competence_based_evaluation_method? && is_competence_based
      get_competence_data(competence_id).max_by { |student| student["competence"]["mark"] }["competence"]["mark"]
    else
      enrolled_students.max_by { |student| student["mark"] }["mark"]
    end
  end

  def student_with_highest_mark(is_competence_based: false, competence_id: nil) # returns an array
    if single_competence_based_evaluation_method? && is_competence_based
      get_competence_data(competence_id).select { |student| student["competence"]["mark"] == highest_mark(is_competence_based: is_competence_based, competence_id: competence_id) }
    else
      enrolled_students.select { |student| student["mark"] == highest_mark }
    end
  end

  def percent_success(is_competence_based: false, competence_id: nil)
    if single_competence_based_evaluation_method? && is_competence_based
      ((student_num_above_average(is_competence_based: is_competence_based, competence_id: competence_id).to_f / enrolled_num.to_f) * 100).round(2)
    else
      ((student_num_above_average.to_f / enrolled_num.to_f) * 100).round(2)
    end
  end

  def get_competence_data(competence_id)
    enrolled_students.map do |student|
      {
        "id" => student["id"].to_i,
        "name" => student["name"],
        "is_enrolled" => student["is_enrolled"], # Convert to boolean
        "mark" => student["mark"].to_f,
        "competence" => student["competences"].select { |competence| competence["id"] == competence_id }.first,
      }
    end
  end

  def teachers_name
    super ? super : teacher.full_name
  end

  private

  # def sequences_per_term
  #   unless self.persisted?
  #     errors.add(:term, "Can not have more than 2 sequences per term") if term.sequences.count == 2
  #   end
  # end

  # def enrollment_num_not_zero
  #   errors.add(:enrollment, "should exist atleast for one student") if enrolled_students.size == 0
  # end

  def set_evaluation_method
    if school_class.should_evaluate_multiple_competences_per_subject
      self.evaluation_method = 1
    else
      self.evaluation_method = 0
    end
  end

  def update_marks_with_total
    if self.single_competence_based_evaluation_method?
      self.marks = hashed_marks.each do |student|
        # Calculate the total mark by summing up the competence marks
        average_competence_mark = student["competences"].sum { |competence| competence["mark"].to_f } / subject.competences.length

        # Update the student hash's "mark" key with the calculated total
        student["mark"] = average_competence_mark.round(2)
      end
    end
  end
end
