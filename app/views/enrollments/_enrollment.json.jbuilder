json.extract! enrollment, :id, :school_id, :student_id, :course_id, :academic_year_id, :semester_id, :created_at, :updated_at
json.url enrollment_url(enrollment, format: :json)
