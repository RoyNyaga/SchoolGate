json.extract! assessment, :id, :school_id, :academic_year_id, :course_id, :semester_id, :type, :marks, :created_at, :updated_at
json.url assessment_url(assessment, format: :json)
