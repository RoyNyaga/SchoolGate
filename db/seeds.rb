# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

teachers = [
  { phone_number: "000000001", name: "Ade George", password: "123456" },
  { phone_number: "000000002", name: "Tanga John", password: "123456" },
  { phone_number: "000000003", name: "Brilliant Ashu", password: "123456" },
  { phone_number: "000000004", name: "Nestor King", password: "123456" },
  { phone_number: "000000005", name: "Nanje Elundo", password: "123456" },
  { phone_number: "000000006", name: "Ivange Lary", password: "123456" },
  { phone_number: "000000007", name: "Fomeki Junior", password: "123456" },
  { phone_number: "000000008", name: "Orock Ojong", password: "123456" },
  { phone_number: "000000009", name: "Mbi Perkings", password: "123456" },
  { phone_number: "000000010", name: "Taboko kinge", password: "123456" },
  { phone_number: "000000011", name: "Peter Esoka", password: "123456" },
  { phone_number: "000000012", name: "max mpako", password: "123456" },
  { phone_number: "000000013", name: "Enow Teddy", password: "123456" },
  { phone_number: "000000014", name: "Christiano Ronaldo", password: "123456" },
  { phone_number: "000000015", name: "Mbog Florence", password: "123456" },
]

@school = School.first

school_classes = [{ name: "Form One", level: 1, school_id: @school.id },
                  { name: "Form Two", level: 2, school_id: @school.id },
                  { name: "Form Three", level: 3, school_id: @school.id },
                  { name: "Form Four", level: 4, school_id: @school.id },
                  { name: "Form Five", level: 5, school_id: @school.id }]

subjects = [
  { name: "English Language", coefficient: 5 }, { name: "French", coefficient: 5 },
  { name: "Manual Labour", coefficient: 2 }, { name: "Literature", coefficient: 3 },
  { name: "Mathematics", coefficient: 5 }, { name: "Physical Education", coefficient: 2 },
  { name: "Computer Science", coefficient: 3 }, { name: "Citizenship", coefficient: 3 },
  { name: "History", coefficient: 3 }, { name: "Biology", coefficient: 3 },
  { name: "Chemistry", coefficient: "Food & NUT" }, { name: "Physics", coefficient: 3 },
  { name: "Geography", coefficient: 3 },
]

# teachers.each do |teacher|
#   Teacher.create(teacher)
# end

SchoolClass.insert_all school_classes

SchoolClass.all.each do |school_class|
  subjects.each do |subject|
    Subject.create(school_id: @school.id, school_class_id: school_class.id, name: subject[:name], coefficient: subject[:coefficient])
  end
end

SchoolClass.all.each do |school_class|
  25.times do
    Student.create(school_id: @school.id, school_class_id: school_class.id,
                   full_name: Faker::Name.name_with_middle, fathers_name: Faker::Name.name_with_middle,
                   fathers_contact: "#{Faker::Number.number(digits: 7)}", mothers_name: Faker::Name.name_with_middle,
                   mothers_contact: "#{Faker::Number.number(digits: 7)}", guidance_name: Faker::Name.name_with_middle,
                   guidance_contact: "#{Faker::Number.number(digits: 7)}", date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 65),
                   address: Faker::Address.full_address)
  end
end
