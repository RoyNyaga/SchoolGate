json.extract! course_registration, :id, :school_id, :student_id, :academic_year_id, :semester_id, :credit_val, :courses, :created_at, :updated_at
json.url course_registration_url(course_registration, format: :json)
