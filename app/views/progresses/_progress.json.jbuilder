json.extract! progress, :id, :school_id, :subject_id, :teacher_id, :topics, :duration, :term_id, :absent_student_ids, :academic_year, :seq_num, :created_at, :updated_at
json.url progress_url(progress, format: :json)
