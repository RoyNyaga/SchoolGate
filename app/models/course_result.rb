class CourseResult < ApplicationRecord
  belongs_to :school
  belongs_to :student
  belongs_to :course
  belongs_to :academic_year
  belongs_to :semester

  def self.parse_course_result(mark, assessment, credit_val)
    h_obj = {
      "school_id" => assessment.school_id,
      "student_id" => mark["id"],
      "course_id" => assessment.course_id,
      "academic_year_id" => assessment.academic_year_id,
      "semester_id" => assessment.semester_id,
      "total_mark" => mark["mark"],
      "credit_val" => credit_val,
    }

    h_obj["#{assessment.assessment_type}_mark"] = mark["mark"]
    h_obj
  end

  def self.get_hash_values(course_results)
    course_results.map(&:attributes)
  end
end
