require "application_system_test_case"

class CourseRegistrationsTest < ApplicationSystemTestCase
  setup do
    @course_registration = course_registrations(:one)
  end

  test "visiting the index" do
    visit course_registrations_url
    assert_selector "h1", text: "Course registrations"
  end

  test "should create course registration" do
    visit course_registrations_url
    click_on "New course registration"

    fill_in "Academic year", with: @course_registration.academic_year_id
    fill_in "Courses", with: @course_registration.courses
    fill_in "Credit val", with: @course_registration.credit_val
    fill_in "School", with: @course_registration.school_id
    fill_in "Semester", with: @course_registration.semester_id
    fill_in "Student", with: @course_registration.student_id
    click_on "Create Course registration"

    assert_text "Course registration was successfully created"
    click_on "Back"
  end

  test "should update Course registration" do
    visit course_registration_url(@course_registration)
    click_on "Edit this course registration", match: :first

    fill_in "Academic year", with: @course_registration.academic_year_id
    fill_in "Courses", with: @course_registration.courses
    fill_in "Credit val", with: @course_registration.credit_val
    fill_in "School", with: @course_registration.school_id
    fill_in "Semester", with: @course_registration.semester_id
    fill_in "Student", with: @course_registration.student_id
    click_on "Update Course registration"

    assert_text "Course registration was successfully updated"
    click_on "Back"
  end

  test "should destroy Course registration" do
    visit course_registration_url(@course_registration)
    click_on "Destroy this course registration", match: :first

    assert_text "Course registration was successfully destroyed"
  end
end
