require "application_system_test_case"

class CourseResultsTest < ApplicationSystemTestCase
  setup do
    @course_result = course_results(:one)
  end

  test "visiting the index" do
    visit course_results_url
    assert_selector "h1", text: "Course results"
  end

  test "should create course result" do
    visit course_results_url
    click_on "New course result"

    fill_in "Academic year", with: @course_result.academic_year_id
    fill_in "Ca mark", with: @course_result.ca_mark
    fill_in "Course", with: @course_result.course_id
    fill_in "Credit val", with: @course_result.credit_val
    fill_in "Exam mark", with: @course_result.exam_mark
    check "Has resit" if @course_result.has_resit
    check "Is validated" if @course_result.is_validated
    fill_in "Resit mark", with: @course_result.resit_mark
    fill_in "School", with: @course_result.school_id
    fill_in "Semester", with: @course_result.semester_id
    fill_in "Student", with: @course_result.student_id
    fill_in "Total mark", with: @course_result.total_mark
    click_on "Create Course result"

    assert_text "Course result was successfully created"
    click_on "Back"
  end

  test "should update Course result" do
    visit course_result_url(@course_result)
    click_on "Edit this course result", match: :first

    fill_in "Academic year", with: @course_result.academic_year_id
    fill_in "Ca mark", with: @course_result.ca_mark
    fill_in "Course", with: @course_result.course_id
    fill_in "Credit val", with: @course_result.credit_val
    fill_in "Exam mark", with: @course_result.exam_mark
    check "Has resit" if @course_result.has_resit
    check "Is validated" if @course_result.is_validated
    fill_in "Resit mark", with: @course_result.resit_mark
    fill_in "School", with: @course_result.school_id
    fill_in "Semester", with: @course_result.semester_id
    fill_in "Student", with: @course_result.student_id
    fill_in "Total mark", with: @course_result.total_mark
    click_on "Update Course result"

    assert_text "Course result was successfully updated"
    click_on "Back"
  end

  test "should destroy Course result" do
    visit course_result_url(@course_result)
    click_on "Destroy this course result", match: :first

    assert_text "Course result was successfully destroyed"
  end
end
