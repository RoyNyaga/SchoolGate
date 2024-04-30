# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# teachers = [
#   { phone_number: "000000011", first_name: "Ade", last_name: "George", password: "123456" },
#   { phone_number: "000000002", first_name: "Tanga", last_name: "John", password: "123456" },
#   { phone_number: "000000003", first_name: "Brilliant", last_name: "Ashu", password: "123456" },
#   { phone_number: "000000004", first_name: "Nestor", last_name: "King", password: "123456" },
#   { phone_number: "000000005", first_name: "Nanje", last_name: "Elundo", password: "123456" },
#   { phone_number: "000000006", first_name: "Ivange", last_name: "Lary", password: "123456" },
#   { phone_number: "000000007", first_name: "Fomeki", last_name: "Junior", password: "123456" },
#   { phone_number: "000000008", first_name: "Orock", last_name: "Ojong", password: "123456" },
#   { phone_number: "000000009", first_name: "Mbi", last_name: "Perkings", password: "123456" },
#   { phone_number: "000000010", first_name: "Taboko", last_name: "kinge", password: "123456" },
#   { phone_number: "000000011", first_name: "Peter", last_name: "Esoka", password: "123456" },
#   { phone_number: "000000012", first_name: "max", last_name: "mpako", password: "123456" },
#   { phone_number: "000000013", first_name: "Enow", last_name: "Teddy", password: "123456" },
#   { phone_number: "000000014", first_name: "Christiano", last_name: "Ronaldo", password: "123456" },
#   { phone_number: "000000015", first_name: "Mbog", last_name: "Florence", password: "123456" },
# ]

@school = School.first

school_classes = [{ name: "Form One", level: 1, school_id: @school.id },
                  { name: "Form Two", level: 2, school_id: @school.id },
                  { name: "Form Three", level: 3, school_id: @school.id },
                  { name: "Form Four", level: 4, school_id: @school.id },
                  { name: "Form Five", level: 5, school_id: @school.id }]

# subjects = [
#   { name: "English Language", coefficient: 5 }, { name: "French", coefficient: 5 },
#   { name: "Manual Labour", coefficient: 2 }, { name: "Literature", coefficient: 3 },
#   { name: "Mathematics", coefficient: 5 }, { name: "Physical Education", coefficient: 2 },
#   { name: "Computer Science", coefficient: 3 }, { name: "Citizenship", coefficient: 3 },
#   { name: "History", coefficient: 3 }, { name: "Biology", coefficient: 3 },
#   { name: "Chemistry", coefficient: "Food & NUT" }, { name: "Physics", coefficient: 3 },
#   { name: "Geography", coefficient: 3 },
# ]

# teachers.each do |teacher|
#   Teacher.create(teacher)
# end

# SchoolClass.insert_all school_classes

# SchoolClass.all.each do |school_class|
#   subjects.each do |subject|
#     Subject.create(school_id: @school.id, school_class_id: school_class.id, name: subject[:name], coefficient: subject[:coefficient])
#   end
# end

SchoolClass.all.each do |school_class|
  25.times do
    Student.create(school_id: @school.id, school_class_id: school_class.id,
                   first_name: Faker::Name.name_with_middle, last_name: Faker::Name.name_with_middle,
                   fathers_name: Faker::Name.last_name, contact: "#{Faker::Number.number(digits: 7)}",
                   gender: [0, 1].sample, address: Faker::Address.full_address,
                   fathers_contact: "#{Faker::Number.number(digits: 7)}", mothers_name: Faker::Name.name_with_middle,
                   mothers_contact: "#{Faker::Number.number(digits: 7)}", guidance_name: Faker::Name.name_with_middle,
                   guidance_contact: "#{Faker::Number.number(digits: 7)}", date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 65))
  end
end

# marks = ["{\"id\"=>\"4\", \"name\"=>\"Allan Powlowski Marquardt\", \"mark\"=>\"#{rand(1..20)}\"}",
#  "{\"id\"=>\"5\", \"name\"=>\"Melynda Bernier Kemmer DDS\", \"mark\"=>\"#{rand(1..20)}\"}",
#          "{\"id\"=>\"6\", \"name\"=>\"Roland Kertzmann Dickens\", \"mark\"=>\"#{rand(1..20)}\"}",
#          "{\"id\"=>\"7\", \"name\"=>\"Beatris Haley Hirthe\", \"mark\"=>\"#{rand(1..20)}\"}",
#          "{\"id\"=>\"8\", \"name\"=>\"Sen. Alessandra Ondricka Davis\", \"mark\"=>\"#{rand(1..20)}\"}",
#          "{\"id\"=>\"9\", \"name\"=>\"Katheleen Dickens Von\", \"mark\"=>\"#{rand(1..20)}\"}",
#          "{\"id\"=>\"10\", \"name\"=>\"Fr. Helaine Nolan Lynch\", \"mark\"=>\"#{rand(1..20)}\"}",
#          "{\"id\"=>\"11\", \"name\"=>\"Loyd Ritchie Harvey\", \"mark\"=>\"#{rand(1..20)}\"}",
#          "{\"id\"=>\"12\", \"name\"=>\"Lajuana Goyette Kuphal\", \"mark\"=>\"#{rand(1..20)}\"}",
#          "{\"id\"=>\"13\", \"name\"=>\"Ms. Marcelino Gleichner Lowe\", \"mark\"=>\"#{rand(1..20)}\"}",
#          "{\"id\"=>\"14\", \"name\"=>\"Bill Lehner Lynch\", \"mark\"=>\"#{rand(1..20)}\"}",
#          "{\"id\"=>\"15\", \"name\"=>\"Miss Whitney Koepp McClure\", \"mark\"=>\"#{rand(1..20)}\"}",
#          "{\"id\"=>\"16\", \"name\"=>\"Angel Walter Nader\", \"mark\"=>\"#{rand(1..20)}\"}",
#          "{\"id\"=>\"17\", \"name\"=>\"Rodger Kreiger Hansen\", \"mark\"=>\"#{rand(1..20)}\"}",
#          "{\"id\"=>\"18\", \"name\"=>\"Pres. Jamie Moore Strosin\", \"mark\"=>\"#{rand(1..20)}\"}",
#          "{\"id\"=>\"19\", \"name\"=>\"Kyong Grant Breitenberg\", \"mark\"=>\"#{rand(1..20)}\"}",
#          "{\"id\"=>\"20\", \"name\"=>\"Gilda Hermann D'Amore\", \"mark\"=>\"#{rand(1..20)}\"}",
#          "{\"id\"=>\"21\", \"name\"=>\"Kirstie Anderson Pagac\", \"mark\"=>\"#{rand(1..20)}\"}",
#          "{\"id\"=>\"22\", \"name\"=>\"Ms. Moon Koelpin Block\", \"mark\"=>\"#{rand(1..20)}\"}",
#          "{\"id\"=>\"23\", \"name\"=>\"Venus Funk Brekke Ret.\", \"mark\"=>\"#{rand(1..20)}\"}",
#          "{\"id\"=>\"24\", \"name\"=>\"Valentin Reichert Nolan DVM\", \"mark\"=>\"#{rand(1..20)}\"}",
#          "{\"id\"=>\"25\", \"name\"=>\"Rolf Larson Greenfelder\", \"mark\"=>\"#{rand(1..20)}\"}",
#          "{\"id\"=>\"26\", \"name\"=>\"Celeste Kessler Kemmer IV\", \"mark\"=>\"#{rand(1..20)}\"}",
#          "{\"id\"=>\"27\", \"name\"=>\"Sammy Cronin Miller\", \"mark\"=>\"#{rand(1..20)}\"}",
#          "{\"id\"=>\"28\", \"name\"=>\"Rep. Ronnie Monahan Gutkowski\", \"mark\"=>\"#{rand(1..20)}\"}"]

# subjects = @school.subjects.where(school_class_id: 3) # subjects for form one

# N::::BBBBBB, always make sure to update the term
subjects.each do |subject|
  [1, 2].each do |v|
    students = Student.where(school_class_id: subject.school_class_id)
    marks = students.map { |s| "{\"id\"=>\"#{s.id}\", \"name\"=>\"#{s.full_name}\", \"mark\"=>\"#{rand(1..20)}\", \"is_enrolled\"=>\"true\"}" }
    # take not of the term id
    if subject.teachers.present?
      puts "create for #{subject.name} - #{subject.id}"
      sequence = Sequence.new(school_id: school.id, subject_id: subject.id, school_class_id: 3, teacher_id: subject.teachers.first.id,
                              seq_num: v, term_id: 4, marks: marks, academic_year_id: school.active_academic_year.id)
      puts sequence.valid?
      unless sequence.valid?
        puts sequence.errors.full_messages
      else
        sequence.save
      end
    else
      puts "create for #{subject.name} - #{subject.id}"
    end
  end
end

fees_hash = { "1" => ["100000", "150000"], "2" => ["50000", "100000"], "3" => ["150000"], "4" => ["200000"],
              "5" => ["250000"], "6" => ["50000", "100000", "100000"], "7" => ["80000", "120000"] }

Student.all.each do |student|
  student.fees.create(school_id: student.school_id, school_class_id: student.school_class_id,
                      academic_year: Student.generate_current_academic_year, installments: fees_hash["#{rand(1..7)}"])
end

teachers.map { |t| Working.create(school_id: @school.id, teacher_id: t.id, permission: 0, agreed_salary: 70000, job_description: "Responsible for teacher studenst") }
