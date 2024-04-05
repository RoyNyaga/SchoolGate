require "application_system_test_case"

class FactultiesTest < ApplicationSystemTestCase
  setup do
    @faculty = faculties(:one)
  end

  test "visiting the index" do
    visit faculties_url
    assert_selector "h1", text: "Factulties"
  end

  test "should create faculty" do
    visit faculties_url
    click_on "New faculty"

    fill_in "Name", with: @faculty.name
    fill_in "School", with: @faculty.school_id
    click_on "Create Factulty"

    assert_text "Factulty was successfully created"
    click_on "Back"
  end

  test "should update Factulty" do
    visit faculty_url(@faculty)
    click_on "Edit this faculty", match: :first

    fill_in "Name", with: @faculty.name
    fill_in "School", with: @faculty.school_id
    click_on "Update Factulty"

    assert_text "Factulty was successfully updated"
    click_on "Back"
  end

  test "should destroy Factulty" do
    visit faculty_url(@faculty)
    click_on "Destroy this faculty", match: :first

    assert_text "Factulty was successfully destroyed"
  end
end
