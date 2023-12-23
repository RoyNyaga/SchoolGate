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

ActiveRecord::Schema[7.1].define(version: 2023_12_23_095400) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.index ["teacher_id"], name: "index_schools_on_teacher_id"
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
    t.index ["school_class_id"], name: "index_subjects_on_school_class_id"
    t.index ["school_id"], name: "index_subjects_on_school_id"
  end

  create_table "teachers", force: :cascade do |t|
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone_number", null: false
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

  add_foreign_key "school_classes", "schools"
  add_foreign_key "schools", "teachers"
  add_foreign_key "students", "school_classes"
  add_foreign_key "students", "schools"
  add_foreign_key "subjects", "school_classes"
  add_foreign_key "subjects", "schools"
  add_foreign_key "teachings", "school_classes"
  add_foreign_key "teachings", "subjects"
  add_foreign_key "teachings", "teachers"
  add_foreign_key "workings", "schools"
  add_foreign_key "workings", "teachers"
end
