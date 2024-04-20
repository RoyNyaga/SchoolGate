json.extract! course_result, :id, :school_id, :student_id, :course_id, :academic_year_id, :semester_id, :ca_mark, :exam_mark, :resit_mark, :total_mark, :has_resit, :is_validated, :credit_val, :created_at, :updated_at
json.url course_result_url(course_result, format: :json)
