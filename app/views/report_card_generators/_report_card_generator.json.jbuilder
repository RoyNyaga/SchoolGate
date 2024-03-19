json.extract! report_card_generator, :id, :academic_year_id, :school_class_id, :term_id, :student_passed_num, :class_average, :school_id, :status, :failed_errors, :most_performed_students, :created_at, :updated_at
json.url report_card_generator_url(report_card_generator, format: :json)
