json.extract! report_card, :id, :school_id, :school_class_id, :term_id, :average, :rank, :class_average, :passed_subjects, :created_at, :updated_at
json.url report_card_url(report_card, format: :json)
