json.extract! student, :id, :school_id, :school_class_id, :full_name, :fathers_name, :fathers_contact, :mothers_name, :mothers_contact, :guidance_name, :guidance_contact, :date_of_birth, :address, :subjects, :created_at, :updated_at
json.url student_url(student, format: :json)
