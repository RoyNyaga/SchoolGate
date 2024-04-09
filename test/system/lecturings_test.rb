require "application_system_test_case"

class LecturingsTest < ApplicationSystemTestCase
  setup do
    @lecturing = lecturings(:one)
  end

  test "visiting the index" do
    visit lecturings_url
    assert_selector "h1", text: "Lecturings"
  end

  test "should create lecturing" do
    visit lecturings_url
    click_on "New lecturing"

    fill_in "Course", with: @lecturing.course_id
    fill_in "Teacher", with: @lecturing.teacher_id
    click_on "Create Lecturing"

    assert_text "Lecturing was successfully created"
    click_on "Back"
  end

  test "should update Lecturing" do
    visit lecturing_url(@lecturing)
    click_on "Edit this lecturing", match: :first

    fill_in "Course", with: @lecturing.course_id
    fill_in "Teacher", with: @lecturing.teacher_id
    click_on "Update Lecturing"

    assert_text "Lecturing was successfully updated"
    click_on "Back"
  end

  test "should destroy Lecturing" do
    visit lecturing_url(@lecturing)
    click_on "Destroy this lecturing", match: :first

    assert_text "Lecturing was successfully destroyed"
  end
end
