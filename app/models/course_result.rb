class CourseResult < ApplicationRecord
  belongs_to :school
  belongs_to :student
  belongs_to :course
  belongs_to :academic_year
  belongs_to :semester
  belongs_to :course_registration

  def self.parse_course_result(mark, assessment, credit_val)
    h_obj = {
      "school_id" => assessment.school_id,
      "student_id" => mark["id"],
      "course_id" => assessment.course_id,
      "academic_year_id" => assessment.academic_year_id,
      "semester_id" => assessment.semester_id,
      "total_mark" => mark["mark"],
      "credit_val" => credit_val,
      "course_registration_id" => mark["course_registration_id"],
    }

    h_obj["#{assessment.assessment_type}_mark"] = mark["mark"]
    h_obj
  end

  def self.get_hash_values(course_results)
    course_results.map(&:attributes)
  end

  def self.calc_gpa(course_results)
    total_marks = course_results.map(&:total_mark)
    sum_total_of_marks = total_marks.sum
    total_average = 100 * total_marks.size # assuming that every final mark is on 100
    average_mark = sum_total_of_marks > 0 ? (sum_total_of_marks / total_average) : 0
    gpa = average_mark * 4 #assuming that
  end

  def self.attempted_credit_val(course_results)
    course_results.map(&:credit_val).sum
  end

  def self.earned_credit_val(course_results)
    course_results.where("total_mark > 50").map(&:credit_val).sum
  end

  def grade
    case total_mark
    when (0..30)
      "F"
    when (31..40)
      "E"
    when (41..45)
      "D"
    when (46..49)
      "D+"
    when (50..55)
      "C"
    when (56..59)
      "C+"
    when (60..69)
      "B"
    when (70..79)
      "B+"
    when (80..100)
      "A"
    else
      "Out of range"
    end
  end
end
