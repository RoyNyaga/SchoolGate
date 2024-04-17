class Assessment < ApplicationRecord
  belongs_to :school
  belongs_to :academic_year
  belongs_to :course
  belongs_to :semester
  belongs_to :academic_year
  belongs_to :teacher

  validates :assessment_type, presence: true

  after_save :manage_course_results

  enum assessment_type: { ca: 1, exam: 2, resit: 3 }
  enum status: { in_progress: 0, submitted: 1, rejected: 2, approved: 3 }

  def hashed_marks
    # parsing marks to ruby hash and converting the mark value to float
    self.marks.map { |m| eval(m) }.map { |a|
      { "id" => a["id"].to_i, "full_name" => a["full_name"], "mark" => a[
        "mark"].to_f, "is_present" => ActiveRecord::Type::Boolean.new.cast((a["is_present"])),
        "course_registration_id" => a["course_registration_id"].to_i, "enrollment_id" => a["enrollment_id"].to_i }
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

  def title
    "#{assessment_type.titleize} - #{semester.semester_type.humanize} - #{academic_year.year}"
  end

  def student_num_above_average
    hashed_marks.count { |mark| mark["mark"] >= 15 }
  end

  def highest_mark
    hashed_marks.max_by { |mark| mark["mark"] }["mark"]
  end

  def student_with_highest_mark # returns an array
    hashed_marks.select { |mark| mark["mark"] == highest_mark }
  end

  def percent_success
    ((student_num_above_average.to_f / hashed_marks.size.to_f) * 100).round(2)
  end

  private

  def update_course_results
    course_results = CourseResult.get_hash_values(course_results_for_the_year)
    marks = hashed_marks
    updated_course_results = []
    ids_of_student_with_result = course_results.map { |course_result| course_result["student_id"] }
    ids_from_marks_submission = marks.map { |mark| mark["id"] }
    ids_of_new_students = ids_from_marks_submission - ids_of_student_with_result
    course_results.each do |course_result|
      mark_type_field = "#{assessment_type}_mark"
      mark = marks.find { |m| m["id"] == course_result["student_id"] }
      course_result[mark_type_field] = mark["mark"]
      course_result["total_mark"] = course_result["ca_mark"] + course_result["exam_mark"] + course_result["resit_mark"]
      updated_course_results << course_result
    end
    CourseResult.upsert_all(updated_course_results) # update existing course results
    if ids_of_new_students.present? # create course results for students who registered later
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
