json.extract! curriculum, :id, :school_id, :school_class_id, :teacher_id, :subject_id, :title, :is_complete, :percent_complete, :created_at, :updated_at
json.url curriculum_url(curriculum, format: :json)
