json.extract! receipt, :id, :school_id, :teacher_id, :academic_year_id, :student_id, :fee_id, :transaction_reference, :has_error, :created_at, :updated_at
json.url receipt_url(receipt, format: :json)
