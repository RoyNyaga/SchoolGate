json.extract! school_approval_request, :id, :school_id, :teacher_id, :school_name, :num_of_student, :education_level, :why_schoolgate, :town, :address, :how_did_you_know_about_us, :created_at, :updated_at
json.url school_approval_request_url(school_approval_request, format: :json)
