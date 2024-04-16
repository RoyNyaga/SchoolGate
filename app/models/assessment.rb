class Assessment < ApplicationRecord
  belongs_to :school
  belongs_to :academic_year
  belongs_to :course
  belongs_to :semester

  validates :assessment_type, presence: true

  after_save :manage_course_results

  enum assessment_type: { ca: 1, exam: 2, resit: 3 }

  def hashed_marks
    # parsing marks to ruby hash and converting the mark value to float
    self.marks.map { |m| eval(m) }.map { |a|
      { "id" => a["id"].to_i, "full_name" => a["full_name"], "mark" => a[
        "mark"].to_f, "is_present" => ActiveRecord::Type::Boolean.new.cast((a["is_present"])),
        "enrollment_id" => a["enrollment_id"].to_i }
    }
  end

  def create_course_results(marks: hashed_marks)
    credit_val = course.credit_value
    bulk_results = marks.map { |mark| CourseResult.parse_course_result(mark, self, credit_val) }
    CourseResult.insert_all bulk_results
  end

  def course_results_for_the_year
    course.course_results.where(academic_year_id: academic_year_id).limit(5)
  end

  def course_results_for_the_year_exists?
    course_results_for_the_year.present?
  end

  private

  def update_course_results
    course_results = CourseResults.get_hash_values(course_results_for_the_year)
    marks = hashed_marks
    ids_of_student_with_result = course_results.map { |course_result| course_result["student_id"] }
    ids_from_marks_submission = marks.map { |mark| mark["id"] }
    ids_of_new_students = ids_from_marks_submission - ids_of_student_with_result
    updated_course_results = course_results.map do |course_result|
      mark_type_field = "#{assessment_type}_mark"
      mark = marks.find { |m| m["id"] == course_result["student_id"] }
      course_result[mark_type_field] = mark["mark"]
      course_result["total_mark"] = course_result["ca_mark"] + course_result["exam_mark"] + course_result["resit_mark"]
    end

    CourseResult.upsert(updated_course_results) # update existing course results
    if ids_of_new_students.present? # create course results for new students
      marks = marks.select { |m| ids_of_new_students.include?(m["id"]) }
      create_course_results(marks: marks)
    end
  end

  def manage_course_results
    if course_results_for_the_year_exists?
      update_course_results
    else
      create_course_results
    end
  end
end
