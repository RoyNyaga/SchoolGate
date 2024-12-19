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
                  fifth_sequence: 5, sith_sequence: 6, first_term_sequence: 7, second_term_sequence: 8,
                  third_term_sequence: 9, test_primary_sequence: 10, exam_primary_sequence: 11, exam_nursery_sequence: 12 }
  enum status: { in_progress: 0, submitted: 1, rejected: 2, approved: 3 }
  enum evaluation_method: { sequence_based_evaluation_method: 0, competence_based_evaluation_method: 1,
                            nursery_evaluation_method: 2, primary_evaluation_method: 3 }

  # validate :validate_sequences_per_term
  validate :validate_enrollment_num_not_zero
  validate :validate_student_presence
  validate :validate_single_sequence_num_type_per_term

  before_save do
    update_marks_with_total
  end

  before_create do
    set_evaluation_method
  end

  def self.allowed_seq_nums(school_class)
    school = school_class.school
    if school.secondary_education?
      if school_class.should_evaluate_multiple_competences_per_subject
        # Return only keys containing "term" if multiple competences should be evaluated
        seq_nums.select { |key, _| key.include?("term") }
      else
        # Exclude keys containing "term" if multiple competences should not be evaluated
        seq_nums.reject { |key, _| key.include?("term") }
      end
    elsif school.basic_education?
      if school_class.nursery_report_card_format?
        seq_nums.select { |key, _| key.include?("nursery") }
      elsif school_class.primary_report_card_format?
        seq_nums.select { |key, _| key.include?("primary") }
      end
    end
  end

  def hashed_marks
    if sequence_based_evaluation_method?
      # parsing marks to ruby hash and converting the mark value to float
      Sequence.string_to_hash_arr(marks).map { |student|
        { "id" => student["id"].to_i, "name" => student["name"], "mark" => student[
          "mark"].to_f, "is_enrolled" => ActiveRecord::Type::Boolean.new.cast(student["is_enrolled"]) }
      }
    elsif competence_based_evaluation_method?
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
    elsif nursery_evaluation_method?
      Sequence.string_to_hash_arr(marks).map { |student|
        { "id" => student["id"].to_i, "name" => student["name"], "mark" => student[
          "mark"], "is_enrolled" => ActiveRecord::Type::Boolean.new.cast(student["is_enrolled"]) }
      }
    elsif primary_evaluation_method?
      Sequence.string_to_hash_arr(marks).map { |student|
        { "id" => student["id"].to_i, "name" => student["name"], "mark" => student[
          "mark"].to_f, "is_enrolled" => ActiveRecord::Type::Boolean.new.cast(student["is_enrolled"]) }
      }
    end
  end

  def enrolled_students
    hashed_marks.select { |student| student["is_enrolled"] == true }
  end

  def sort_by_mark_desc(is_competence_based: false, competence_id: nil)
    if competence_based_evaluation_method? && is_competence_based
      get_competence_data(competence_id).sort_by { |student| -student["competence"]["mark"] }
    else
      enrolled_students.sort_by { |item| -item["mark"] }
    end
  end

  def sort_by_student_name_desc
    enrolled_students.sort_by { |item| -item["name"] }
  end

  def seq_title(with_class_name: false)
    with_class_name ? "#{name} - #{seq_num} - #{term_type} - #{academic_year.year}" :
      "#{seq_num} - #{term_type} - #{academic_year.year}"
  end

  def enrolled_num
    enrolled_students.count
  end

  def student_num_above_average(is_competence_based: false, competence_id: nil)
    if competence_based_evaluation_method? && is_competence_based
      get_competence_data(competence_id).count { |student| student["competence"]["mark"] >= 10 }
    else
      enrolled_students.count { |student| student["mark"] >= 10 }
    end
  end

  def highest_mark(is_competence_based: false, competence_id: nil)
    if competence_based_evaluation_method? && is_competence_based
      get_competence_data(competence_id).max_by { |student| student["competence"]["mark"] }["competence"]["mark"]
    else
      enrolled_students.max_by { |student| student["mark"] }["mark"]
    end
  end

  def student_with_highest_mark(is_competence_based: false, competence_id: nil) # returns an array
    if competence_based_evaluation_method? && is_competence_based
      get_competence_data(competence_id).select { |student| student["competence"]["mark"] == highest_mark(is_competence_based: is_competence_based, competence_id: competence_id) }
    else
      enrolled_students.select { |student| student["mark"] == highest_mark }
    end
  end

  def percent_success(is_competence_based: false, competence_id: nil)
    if competence_based_evaluation_method? && is_competence_based
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

  private

  # def validate_sequences_per_term
  #   unless self.persisted?
  #     errors.add(:term, "Can not have more than 2 sequences per term for a subject") if subject.sequences.size == 2
  #   end
  # end

  def validate_student_presence
    errors.add(:students, "Student must exist in a class.") if marks.blank?
  end

  def validate_enrollment_num_not_zero
    errors.add(:enrollment, "should exist atleast for one student") if enrolled_students.size == 0
  end

  def set_evaluation_method
    school = school_class.school
    if school.secondary_education?
      if school_class.should_evaluate_multiple_competences_per_subject
        self.evaluation_method = 1
      else
        self.evaluation_method = 0
      end
    elsif school.basic_education?
      if school_class.nursery_report_card_format?
        self.evaluation_method = 2
      elsif school_class.primary_report_card_format?
        self.evaluation_method = 3
      end
    end
  end

  def update_marks_with_total
    if self.competence_based_evaluation_method?
      self.marks = hashed_marks.each do |student|
        # Calculate the total mark by summing up the competence marks
        average_competence_mark = student["competences"].sum { |competence| competence["mark"].to_f } / subject.competences.length

        # Update the student hash's "mark" key with the calculated total
        student["mark"] = average_competence_mark.round(2)
      end
    end
  end

  def validate_single_sequence_num_type_per_term # One subject should not have 2 same sequences for one term
    unless self.persisted?
      errors.add(:sequence, "duplicate sequence type for One term") if term.sequences.where(subject_id: subject_id, seq_num: seq_num).size == 1
    end
  end

  # check if terms in term dropdown are mapped to academic year
end
