require "application_system_test_case"

class SemestersTest < ApplicationSystemTestCase
  setup do
    @semester = semesters(:one)
  end

  test "visiting the index" do
    visit semesters_url
    assert_selector "h1", text: "Semesters"
  end

  test "should create semester" do
    visit semesters_url
    click_on "New semester"

    fill_in "Academic year", with: @semester.academic_year_id
    fill_in "School", with: @semester.school_id
    fill_in "Type", with: @semester.type
    click_on "Create Semester"

    assert_text "Semester was successfully created"
    click_on "Back"
  end

  test "should update Semester" do
    visit semester_url(@semester)
    click_on "Edit this semester", match: :first

    fill_in "Academic year", with: @semester.academic_year_id
    fill_in "School", with: @semester.school_id
    fill_in "Type", with: @semester.type
    click_on "Update Semester"

    assert_text "Semester was successfully updated"
    click_on "Back"
  end

  test "should destroy Semester" do
    visit semester_url(@semester)
    click_on "Destroy this semester", match: :first

    assert_text "Semester was successfully destroyed"
  end
end
