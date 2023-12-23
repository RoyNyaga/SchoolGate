require "application_system_test_case"

class WorkingsTest < ApplicationSystemTestCase
  setup do
    @working = workings(:one)
  end

  test "visiting the index" do
    visit workings_url
    assert_selector "h1", text: "Workings"
  end

  test "should create working" do
    visit workings_url
    click_on "New working"

    fill_in "Agreed salary", with: @working.agreed_salary
    fill_in "Job description", with: @working.job_description
    fill_in "Permission", with: @working.permission
    fill_in "School", with: @working.school_id
    fill_in "Teacher", with: @working.teacher_id
    click_on "Create Working"

    assert_text "Working was successfully created"
    click_on "Back"
  end

  test "should update Working" do
    visit working_url(@working)
    click_on "Edit this working", match: :first

    fill_in "Agreed salary", with: @working.agreed_salary
    fill_in "Job description", with: @working.job_description
    fill_in "Permission", with: @working.permission
    fill_in "School", with: @working.school_id
    fill_in "Teacher", with: @working.teacher_id
    click_on "Update Working"

    assert_text "Working was successfully updated"
    click_on "Back"
  end

  test "should destroy Working" do
    visit working_url(@working)
    click_on "Destroy this working", match: :first

    assert_text "Working was successfully destroyed"
  end
end
