require "application_system_test_case"

class StudentsTest < ApplicationSystemTestCase
  setup do
    @student = students(:one)
  end

  test "visiting the index" do
    visit students_url
    assert_selector "h1", text: "Students"
  end

  test "should create student" do
    visit students_url
    click_on "New student"

    fill_in "Address", with: @student.address
    fill_in "Date of birth", with: @student.date_of_birth
    fill_in "Fathers contact", with: @student.fathers_contact
    fill_in "Fathers name", with: @student.fathers_name
    fill_in "Full name", with: @student.full_name
    fill_in "Guidance contact", with: @student.guidance_contact
    fill_in "Guidance name", with: @student.guidance_name
    fill_in "Mothers contact", with: @student.mothers_contact
    fill_in "Mothers name", with: @student.mothers_name
    fill_in "School class", with: @student.school_class_id
    fill_in "School", with: @student.school_id
    fill_in "Subjects", with: @student.subjects
    click_on "Create Student"

    assert_text "Student was successfully created"
    click_on "Back"
  end

  test "should update Student" do
    visit student_url(@student)
    click_on "Edit this student", match: :first

    fill_in "Address", with: @student.address
    fill_in "Date of birth", with: @student.date_of_birth
    fill_in "Fathers contact", with: @student.fathers_contact
    fill_in "Fathers name", with: @student.fathers_name
    fill_in "Full name", with: @student.full_name
    fill_in "Guidance contact", with: @student.guidance_contact
    fill_in "Guidance name", with: @student.guidance_name
    fill_in "Mothers contact", with: @student.mothers_contact
    fill_in "Mothers name", with: @student.mothers_name
    fill_in "School class", with: @student.school_class_id
    fill_in "School", with: @student.school_id
    fill_in "Subjects", with: @student.subjects
    click_on "Update Student"

    assert_text "Student was successfully updated"
    click_on "Back"
  end

  test "should destroy Student" do
    visit student_url(@student)
    click_on "Destroy this student", match: :first

    assert_text "Student was successfully destroyed"
  end
end
