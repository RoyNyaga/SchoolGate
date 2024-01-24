json.extract! fee, :id, :school_id, :school_class_id, :teacher_id, :student_id, :academic_year_start, :academic_year_end, :installments, :installment_num, :total_feee_paid, :is_completed, :created_at, :updated_at
json.url fee_url(fee, format: :json)
