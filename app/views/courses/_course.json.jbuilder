json.extract! course, :id, :school_id, :faculty_id, :department_id, :name, :credit_value, :created_at, :updated_at
json.url course_url(course, format: :json)
