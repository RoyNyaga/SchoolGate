# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_05_21_073635) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "absences", force: :cascade do |t|
    t.bigint "school_id", null: false
    t.bigint "student_id", null: false
    t.bigint "progress_id", null: false
    t.bigint "term_id", null: false
    t.string "academic_year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["progress_id"], name: "index_absences_on_progress_id"
    t.index ["school_id"], name: "index_absences_on_school_id"
    t.index ["student_id"], name: "index_absences_on_student_id"
    t.index ["term_id"], name: "index_absences_on_term_id"
  end

  create_table "academic_years", force: :cascade do |t|
    t.bigint "school_id", null: false
    t.string "year"
    t.boolean "is_active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["school_id"], name: "index_academic_years_on_school_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "assessments", force: :cascade do |t|
    t.bigint "school_id", null: false
    t.bigint "academic_year_id", null: false
    t.bigint "course_id", null: false
    t.bigint "semester_id", null: false
    t.integer "assessment_type", default: 0
    t.text "marks", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "course_name"
    t.bigint "teacher_id", null: false
    t.integer "status", default: 0
    t.index ["academic_year_id"], name: "index_assessments_on_academic_year_id"
    t.index ["course_id"], name: "index_assessments_on_course_id"
    t.index ["school_id"], name: "index_assessments_on_school_id"
    t.index ["semester_id"], name: "index_assessments_on_semester_id"
    t.index ["teacher_id"], name: "index_assessments_on_teacher_id"
  end

  create_table "course_registrations", force: :cascade do |t|
    t.bigint "school_id", null: false
    t.bigint "student_id", null: false
    t.bigint "academic_year_id", null: false
    t.bigint "semester_id", null: false
    t.integer "credit_val", default: 0
    t.text "courses", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["academic_year_id"], name: "index_course_registrations_on_academic_year_id"
    t.index ["school_id"], name: "index_course_registrations_on_school_id"
    t.index ["semester_id"], name: "index_course_registrations_on_semester_id"
    t.index ["student_id"], name: "index_course_registrations_on_student_id"
  end

  create_table "course_results", force: :cascade do |t|
    t.bigint "school_id", null: false
    t.bigint "student_id", null: false
    t.bigint "course_id", null: false
    t.bigint "academic_year_id", null: false
    t.bigint "semester_id", null: false
    t.float "ca_mark", default: 0.0
    t.float "exam_mark", default: 0.0
    t.float "resit_mark", default: 0.0
    t.float "total_mark", default: 0.0
    t.boolean "has_resit", default: false
    t.boolean "is_validated", default: false
    t.integer "credit_val"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "course_registration_id"
    t.index ["academic_year_id"], name: "index_course_results_on_academic_year_id"
    t.index ["course_id"], name: "index_course_results_on_course_id"
    t.index ["course_registration_id"], name: "index_course_results_on_course_registration_id"
    t.index ["school_id"], name: "index_course_results_on_school_id"
    t.index ["semester_id"], name: "index_course_results_on_semester_id"
    t.index ["student_id"], name: "index_course_results_on_student_id"
  end

  create_table "courses", force: :cascade do |t|
    t.bigint "school_id", null: false
    t.bigint "faculty_id", null: false
    t.bigint "department_id", null: false
    t.string "name", null: false
    t.integer "credit_value", null: false
    t.string "abbreviation", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "complete_name"
    t.index ["department_id"], name: "index_courses_on_department_id"
    t.index ["faculty_id"], name: "index_courses_on_faculty_id"
    t.index ["school_id"], name: "index_courses_on_school_id"
  end

  create_table "curriculums", force: :cascade do |t|
    t.bigint "school_id", null: false
    t.bigint "school_class_id", null: false
    t.bigint "teacher_id", null: false
    t.bigint "subject_id", null: false
    t.string "title"
    t.float "percent_complete", default: 0.0
    t.string "academic_year", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_complete", default: false
    t.index ["school_class_id"], name: "index_curriculums_on_school_class_id"
    t.index ["school_id"], name: "index_curriculums_on_school_id"
    t.index ["subject_id"], name: "index_curriculums_on_subject_id"
    t.index ["teacher_id"], name: "index_curriculums_on_teacher_id"
  end

  create_table "departments", force: :cascade do |t|
    t.bigint "school_id", null: false
    t.bigint "faculty_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["faculty_id"], name: "index_departments_on_faculty_id"
    t.index ["school_id"], name: "index_departments_on_school_id"
  end

  create_table "enrollments", force: :cascade do |t|
    t.bigint "school_id", null: false
    t.bigint "student_id", null: false
    t.bigint "course_id", null: false
    t.bigint "academic_year_id", null: false
    t.bigint "semester_id", null: false
    t.bigint "course_registration_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["academic_year_id"], name: "index_enrollments_on_academic_year_id"
    t.index ["course_id"], name: "index_enrollments_on_course_id"
    t.index ["course_registration_id"], name: "index_enrollments_on_course_registration_id"
    t.index ["school_id"], name: "index_enrollments_on_school_id"
    t.index ["semester_id"], name: "index_enrollments_on_semester_id"
    t.index ["student_id"], name: "index_enrollments_on_student_id"
  end

  create_table "faculties", force: :cascade do |t|
    t.bigint "school_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["school_id"], name: "index_faculties_on_school_id"
  end

  create_table "fees", force: :cascade do |t|
    t.bigint "school_id", null: false
    t.bigint "school_class_id", null: false
    t.bigint "student_id", null: false
    t.text "update_records", default: [], array: true
    t.string "academic_year_text", null: false
    t.text "installments", default: [], array: true
    t.integer "installment_num", default: 0
    t.integer "total_fee_paid", default: 0
    t.boolean "is_completed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "percentage_complete", default: 0.0
    t.bigint "academic_year_id"
    t.float "receipt_amount"
    t.boolean "is_receipt_and_fee_amount_in_phase", default: true
    t.index ["academic_year_id"], name: "index_fees_on_academic_year_id"
    t.index ["school_class_id"], name: "index_fees_on_school_class_id"
    t.index ["school_id"], name: "index_fees_on_school_id"
    t.index ["student_id"], name: "index_fees_on_student_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.bigint "sender_id", null: false
    t.bigint "teacher_id", null: false
    t.bigint "school_id", null: false
    t.integer "permission", default: 0
    t.float "proposed_salary", default: 0.0
    t.text "job_description"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["school_id"], name: "index_invitations_on_school_id"
    t.index ["sender_id"], name: "index_invitations_on_sender_id"
    t.index ["teacher_id"], name: "index_invitations_on_teacher_id"
  end

  create_table "lecturings", force: :cascade do |t|
    t.bigint "course_id", null: false
    t.bigint "teacher_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_lecturings_on_course_id"
    t.index ["teacher_id"], name: "index_lecturings_on_teacher_id"
  end

  create_table "main_topics", force: :cascade do |t|
    t.bigint "teacher_id", null: false
    t.bigint "curriculum_id", null: false
    t.bigint "subject_id", null: false
    t.string "title", null: false
    t.boolean "is_complete", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "percent_complete", default: 0.0
    t.index ["curriculum_id"], name: "index_main_topics_on_curriculum_id"
    t.index ["subject_id"], name: "index_main_topics_on_subject_id"
    t.index ["teacher_id"], name: "index_main_topics_on_teacher_id"
  end

  create_table "progresses", force: :cascade do |t|
    t.bigint "school_id", null: false
    t.bigint "subject_id", null: false
    t.bigint "teacher_id", null: false
    t.bigint "term_id", null: false
    t.text "topics", default: [], array: true
    t.text "absent_students", default: [], array: true
    t.string "academic_year", null: false
    t.integer "seq_num", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "school_class_id", null: false
    t.jsonb "period_duration", default: {"mins"=>0, "hours"=>0}
    t.index ["school_class_id"], name: "index_progresses_on_school_class_id"
    t.index ["school_id"], name: "index_progresses_on_school_id"
    t.index ["subject_id"], name: "index_progresses_on_subject_id"
    t.index ["teacher_id"], name: "index_progresses_on_teacher_id"
    t.index ["term_id"], name: "index_progresses_on_term_id"
  end

  create_table "receipts", force: :cascade do |t|
    t.bigint "school_id", null: false
    t.bigint "teacher_id", null: false
    t.bigint "academic_year_id", null: false
    t.bigint "student_id", null: false
    t.bigint "fee_id", null: false
    t.string "transaction_reference", null: false
    t.boolean "has_error", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "amount"
    t.json "update_history", default: {}
    t.index ["academic_year_id"], name: "index_receipts_on_academic_year_id"
    t.index ["fee_id"], name: "index_receipts_on_fee_id"
    t.index ["school_id"], name: "index_receipts_on_school_id"
    t.index ["student_id"], name: "index_receipts_on_student_id"
    t.index ["teacher_id"], name: "index_receipts_on_teacher_id"
    t.index ["transaction_reference"], name: "index_receipts_on_transaction_reference"
  end

  create_table "report_card_generators", force: :cascade do |t|
    t.bigint "academic_year_id", null: false
    t.bigint "school_class_id", null: false
    t.bigint "term_id", null: false
    t.integer "student_passed_num"
    t.float "class_average"
    t.bigint "school_id", null: false
    t.integer "progress_state", default: 0
    t.boolean "is_successful", default: false
    t.text "failed_errors", default: [], array: true
    t.text "most_performed_students", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "warning_messages", default: [], array: true
    t.float "process_duration", default: 0.0
    t.text "least_performed_students", default: [], array: true
    t.integer "student_num"
    t.boolean "is_processing", default: false
    t.index ["academic_year_id"], name: "index_report_card_generators_on_academic_year_id"
    t.index ["school_class_id"], name: "index_report_card_generators_on_school_class_id"
    t.index ["school_id"], name: "index_report_card_generators_on_school_id"
    t.index ["term_id"], name: "index_report_card_generators_on_term_id"
  end

  create_table "report_cards", force: :cascade do |t|
    t.bigint "school_id", null: false
    t.bigint "school_class_id", null: false
    t.bigint "term_id", null: false
    t.float "average"
    t.integer "rank"
    t.float "class_average"
    t.integer "passed_subjects"
    t.text "details", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "student_id", null: false
    t.float "total_score", default: 0.0
    t.float "total_coefficient", default: 0.0
    t.bigint "academic_year_id", null: false
    t.bigint "report_card_generator_id", default: 3, null: false
    t.index ["academic_year_id"], name: "index_report_cards_on_academic_year_id"
    t.index ["report_card_generator_id"], name: "index_report_cards_on_report_card_generator_id"
    t.index ["school_class_id"], name: "index_report_cards_on_school_class_id"
    t.index ["school_id"], name: "index_report_cards_on_school_id"
    t.index ["student_id"], name: "index_report_cards_on_student_id"
    t.index ["term_id"], name: "index_report_cards_on_term_id"
  end

  create_table "school_classes", force: :cascade do |t|
    t.bigint "school_id", null: false
    t.string "name"
    t.integer "level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["school_id"], name: "index_school_classes_on_school_id"
  end

  create_table "schools", force: :cascade do |t|
    t.bigint "teacher_id", null: false
    t.string "full_name", null: false
    t.string "abbreviation"
    t.string "town"
    t.string "address"
    t.string "moto"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "school_fees_settings", default: {}
    t.jsonb "student_id_settings", default: {}
    t.integer "education_level", default: 1
    t.index ["teacher_id"], name: "index_schools_on_teacher_id"
  end

  create_table "semesters", force: :cascade do |t|
    t.bigint "school_id", null: false
    t.bigint "academic_year_id", null: false
    t.integer "semester_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_active", default: false
    t.index ["academic_year_id"], name: "index_semesters_on_academic_year_id"
    t.index ["school_id"], name: "index_semesters_on_school_id"
  end

  create_table "sequences", force: :cascade do |t|
    t.bigint "school_id", null: false
    t.bigint "school_class_id", null: false
    t.bigint "teacher_id", null: false
    t.integer "seq_num", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "marks", default: [], array: true
    t.bigint "subject_id", null: false
    t.bigint "term_id"
    t.bigint "academic_year_id", default: 1, null: false
    t.integer "status", default: 0
    t.index ["academic_year_id"], name: "index_sequences_on_academic_year_id"
    t.index ["school_class_id"], name: "index_sequences_on_school_class_id"
    t.index ["school_id"], name: "index_sequences_on_school_id"
    t.index ["subject_id"], name: "index_sequences_on_subject_id"
    t.index ["teacher_id"], name: "index_sequences_on_teacher_id"
    t.index ["term_id"], name: "index_sequences_on_term_id"
  end

  create_table "solid_queue_blocked_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.string "concurrency_key", null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.index ["concurrency_key", "priority", "job_id"], name: "index_solid_queue_blocked_executions_for_release"
    t.index ["expires_at", "concurrency_key"], name: "index_solid_queue_blocked_executions_for_maintenance"
    t.index ["job_id"], name: "index_solid_queue_blocked_executions_on_job_id", unique: true
  end

  create_table "solid_queue_claimed_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.bigint "process_id"
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_claimed_executions_on_job_id", unique: true
    t.index ["process_id", "job_id"], name: "index_solid_queue_claimed_executions_on_process_id_and_job_id"
  end

  create_table "solid_queue_failed_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.text "error"
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_failed_executions_on_job_id", unique: true
  end

  create_table "solid_queue_jobs", force: :cascade do |t|
    t.string "queue_name", null: false
    t.string "class_name", null: false
    t.text "arguments"
    t.integer "priority", default: 0, null: false
    t.string "active_job_id"
    t.datetime "scheduled_at"
    t.datetime "finished_at"
    t.string "concurrency_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active_job_id"], name: "index_solid_queue_jobs_on_active_job_id"
    t.index ["class_name"], name: "index_solid_queue_jobs_on_class_name"
    t.index ["finished_at"], name: "index_solid_queue_jobs_on_finished_at"
    t.index ["queue_name", "finished_at"], name: "index_solid_queue_jobs_for_filtering"
    t.index ["scheduled_at", "finished_at"], name: "index_solid_queue_jobs_for_alerting"
  end

  create_table "solid_queue_pauses", force: :cascade do |t|
    t.string "queue_name", null: false
    t.datetime "created_at", null: false
    t.index ["queue_name"], name: "index_solid_queue_pauses_on_queue_name", unique: true
  end

  create_table "solid_queue_processes", force: :cascade do |t|
    t.string "kind", null: false
    t.datetime "last_heartbeat_at", null: false
    t.bigint "supervisor_id"
    t.integer "pid", null: false
    t.string "hostname"
    t.text "metadata"
    t.datetime "created_at", null: false
    t.index ["last_heartbeat_at"], name: "index_solid_queue_processes_on_last_heartbeat_at"
    t.index ["supervisor_id"], name: "index_solid_queue_processes_on_supervisor_id"
  end

  create_table "solid_queue_ready_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_ready_executions_on_job_id", unique: true
    t.index ["priority", "job_id"], name: "index_solid_queue_poll_all"
    t.index ["queue_name", "priority", "job_id"], name: "index_solid_queue_poll_by_queue"
  end

  create_table "solid_queue_scheduled_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.datetime "scheduled_at", null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_scheduled_executions_on_job_id", unique: true
    t.index ["scheduled_at", "priority", "job_id"], name: "index_solid_queue_dispatch_all"
  end

  create_table "solid_queue_semaphores", force: :cascade do |t|
    t.string "key", null: false
    t.integer "value", default: 1, null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expires_at"], name: "index_solid_queue_semaphores_on_expires_at"
    t.index ["key", "value"], name: "index_solid_queue_semaphores_on_key_and_value"
    t.index ["key"], name: "index_solid_queue_semaphores_on_key", unique: true
  end

  create_table "students", force: :cascade do |t|
    t.bigint "school_id", null: false
    t.bigint "school_class_id", null: false
    t.string "full_name"
    t.string "fathers_name"
    t.string "fathers_contact"
    t.string "mothers_name"
    t.string "mothers_contact"
    t.string "guidance_name"
    t.string "guidance_contact"
    t.date "date_of_birth"
    t.string "address"
    t.string "subjects"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "town"
    t.string "matricule"
    t.string "portal_code"
    t.string "first_name"
    t.string "last_name"
    t.text "previous_classes", default: [], array: true
    t.string "contact"
    t.integer "status", default: 0
    t.integer "education_level", default: 2
    t.integer "faculty_id"
    t.integer "department_id"
    t.integer "gender", default: 0, null: false
    t.index ["school_class_id"], name: "index_students_on_school_class_id"
    t.index ["school_id"], name: "index_students_on_school_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.bigint "school_id", null: false
    t.bigint "school_class_id", null: false
    t.string "name", null: false
    t.float "coefficient", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "remarks", default: {"less_than_equal_to_5"=>"Very poor", "less_than_equal_to_9"=>"Poor", "less_than_equal_to_12"=>"Average", "less_than_equal_to_15"=>"Good", "less_than_equal_to_18"=>"V good", "less_than_equal_to_20"=>"Excellent"}
    t.index ["school_class_id"], name: "index_subjects_on_school_class_id"
    t.index ["school_id"], name: "index_subjects_on_school_id"
  end

  create_table "teacher_ques", force: :cascade do |t|
    t.string "full_name"
    t.string "phone_number"
    t.string "name_of_schools_taught"
    t.string "location_of_schools"
    t.string "education_level"
    t.text "subjects_taught", default: [], array: true
    t.string "progress_importance"
    t.text "most_usefull_feature", default: [], array: true
    t.string "comfort_in_filling_progress"
    t.string "track_hours_usefulness"
    t.string "online_report_cards"
    t.jsonb "referal", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teachers", force: :cascade do |t|
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone_number", null: false
    t.string "full_name", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "town"
    t.index ["phone_number"], name: "index_teachers_on_phone_number", unique: true
    t.index ["reset_password_token"], name: "index_teachers_on_reset_password_token", unique: true
  end

  create_table "teachings", force: :cascade do |t|
    t.bigint "teacher_id", null: false
    t.bigint "subject_id", null: false
    t.bigint "school_class_id", null: false
    t.boolean "is_class_master"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["school_class_id"], name: "index_teachings_on_school_class_id"
    t.index ["subject_id"], name: "index_teachings_on_subject_id"
    t.index ["teacher_id"], name: "index_teachings_on_teacher_id"
  end

  create_table "terms", force: :cascade do |t|
    t.bigint "school_id", null: false
    t.integer "term_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "academic_year_id", default: 1
    t.index ["academic_year_id"], name: "index_terms_on_academic_year_id"
    t.index ["school_id"], name: "index_terms_on_school_id"
  end

  create_table "topics", force: :cascade do |t|
    t.bigint "teacher_id", null: false
    t.bigint "main_topic_id", null: false
    t.bigint "subject_id", null: false
    t.string "title", null: false
    t.integer "progress", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["main_topic_id"], name: "index_topics_on_main_topic_id"
    t.index ["subject_id"], name: "index_topics_on_subject_id"
    t.index ["teacher_id"], name: "index_topics_on_teacher_id"
  end

  create_table "workings", force: :cascade do |t|
    t.bigint "school_id", null: false
    t.bigint "teacher_id", null: false
    t.integer "permission", default: 0
    t.float "agreed_salary", default: 0.0
    t.string "job_description"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["school_id"], name: "index_workings_on_school_id"
    t.index ["teacher_id"], name: "index_workings_on_teacher_id"
  end

  add_foreign_key "absences", "progresses"
  add_foreign_key "absences", "schools"
  add_foreign_key "absences", "students"
  add_foreign_key "absences", "terms"
  add_foreign_key "academic_years", "schools"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "assessments", "academic_years"
  add_foreign_key "assessments", "courses"
  add_foreign_key "assessments", "schools"
  add_foreign_key "assessments", "semesters"
  add_foreign_key "assessments", "teachers"
  add_foreign_key "course_registrations", "academic_years"
  add_foreign_key "course_registrations", "schools"
  add_foreign_key "course_registrations", "semesters"
  add_foreign_key "course_registrations", "students"
  add_foreign_key "course_results", "academic_years"
  add_foreign_key "course_results", "course_registrations"
  add_foreign_key "course_results", "courses"
  add_foreign_key "course_results", "schools"
  add_foreign_key "course_results", "semesters"
  add_foreign_key "course_results", "students"
  add_foreign_key "courses", "departments"
  add_foreign_key "courses", "faculties"
  add_foreign_key "courses", "schools"
  add_foreign_key "curriculums", "school_classes"
  add_foreign_key "curriculums", "schools"
  add_foreign_key "curriculums", "subjects"
  add_foreign_key "curriculums", "teachers"
  add_foreign_key "departments", "faculties"
  add_foreign_key "departments", "schools"
  add_foreign_key "enrollments", "academic_years"
  add_foreign_key "enrollments", "course_registrations"
  add_foreign_key "enrollments", "courses"
  add_foreign_key "enrollments", "schools"
  add_foreign_key "enrollments", "semesters"
  add_foreign_key "enrollments", "students"
  add_foreign_key "faculties", "schools"
  add_foreign_key "fees", "academic_years"
  add_foreign_key "fees", "school_classes"
  add_foreign_key "fees", "schools"
  add_foreign_key "fees", "students"
  add_foreign_key "invitations", "schools"
  add_foreign_key "invitations", "teachers"
  add_foreign_key "lecturings", "courses"
  add_foreign_key "lecturings", "teachers"
  add_foreign_key "main_topics", "curriculums"
  add_foreign_key "main_topics", "subjects"
  add_foreign_key "main_topics", "teachers"
  add_foreign_key "progresses", "school_classes"
  add_foreign_key "progresses", "schools"
  add_foreign_key "progresses", "subjects"
  add_foreign_key "progresses", "teachers"
  add_foreign_key "progresses", "terms"
  add_foreign_key "receipts", "academic_years"
  add_foreign_key "receipts", "fees"
  add_foreign_key "receipts", "schools"
  add_foreign_key "receipts", "students"
  add_foreign_key "receipts", "teachers"
  add_foreign_key "report_card_generators", "academic_years"
  add_foreign_key "report_card_generators", "school_classes"
  add_foreign_key "report_card_generators", "schools"
  add_foreign_key "report_card_generators", "terms"
  add_foreign_key "report_cards", "academic_years"
  add_foreign_key "report_cards", "report_card_generators"
  add_foreign_key "report_cards", "school_classes"
  add_foreign_key "report_cards", "schools"
  add_foreign_key "report_cards", "students"
  add_foreign_key "report_cards", "terms"
  add_foreign_key "school_classes", "schools"
  add_foreign_key "schools", "teachers"
  add_foreign_key "semesters", "academic_years"
  add_foreign_key "semesters", "schools"
  add_foreign_key "sequences", "academic_years"
  add_foreign_key "sequences", "school_classes"
  add_foreign_key "sequences", "schools"
  add_foreign_key "sequences", "subjects"
  add_foreign_key "sequences", "teachers"
  add_foreign_key "sequences", "terms"
  add_foreign_key "solid_queue_blocked_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_claimed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_failed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_ready_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_scheduled_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "students", "school_classes"
  add_foreign_key "students", "schools"
  add_foreign_key "subjects", "school_classes"
  add_foreign_key "subjects", "schools"
  add_foreign_key "teachings", "school_classes"
  add_foreign_key "teachings", "subjects"
  add_foreign_key "teachings", "teachers"
  add_foreign_key "terms", "academic_years"
  add_foreign_key "terms", "schools"
  add_foreign_key "topics", "main_topics"
  add_foreign_key "topics", "subjects"
  add_foreign_key "topics", "teachers"
  add_foreign_key "workings", "schools"
  add_foreign_key "workings", "teachers"
end
