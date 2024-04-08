require "application_system_test_case"

class CoursesTest < ApplicationSystemTestCase
  setup do
    @course = courses(:one)
  end

  test "visiting the index" do
    visit courses_url
    assert_selector "h1", text: "Courses"
  end

  test "should create course" do
    visit courses_url
    click_on "New course"

    fill_in "Credit value", with: @course.credit_value
    fill_in "Department", with: @course.department_id
    fill_in "Faculty", with: @course.faculty_id
    fill_in "Name", with: @course.name
    fill_in "School", with: @course.school_id
    click_on "Create Course"

    assert_text "Course was successfully created"
    click_on "Back"
  end

  test "should update Course" do
    visit course_url(@course)
    click_on "Edit this course", match: :first

    fill_in "Credit value", with: @course.credit_value
    fill_in "Department", with: @course.department_id
    fill_in "Faculty", with: @course.faculty_id
    fill_in "Name", with: @course.name
    fill_in "School", with: @course.school_id
    click_on "Update Course"

    assert_text "Course was successfully updated"
    click_on "Back"
  end

  test "should destroy Course" do
    visit course_url(@course)
    click_on "Destroy this course", match: :first

    assert_text "Course was successfully destroyed"
  end
end