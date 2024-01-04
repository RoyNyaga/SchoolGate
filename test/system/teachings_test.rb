require "application_system_test_case"

class TeachingsTest < ApplicationSystemTestCase
  setup do
    @teaching = teachings(:one)
  end

  test "visiting the index" do
    visit teachings_url
    assert_selector "h1", text: "Teachings"
  end

  test "should create teaching" do
    visit teachings_url
    click_on "New teaching"

    check "Is class master" if @teaching.is_class_master
    fill_in "School class", with: @teaching.school_class_id
    fill_in "Subject", with: @teaching.subject_id
    fill_in "Teacher", with: @teaching.teacher_id
    click_on "Create Teaching"

    assert_text "Teaching was successfully created"
    click_on "Back"
  end

  test "should update Teaching" do
    visit teaching_url(@teaching)
    click_on "Edit this teaching", match: :first

    check "Is class master" if @teaching.is_class_master
    fill_in "School class", with: @teaching.school_class_id
    fill_in "Subject", with: @teaching.subject_id
    fill_in "Teacher", with: @teaching.teacher_id
    click_on "Update Teaching"

    assert_text "Teaching was successfully updated"
    click_on "Back"
  end

  test "should destroy Teaching" do
    visit teaching_url(@teaching)
    click_on "Destroy this teaching", match: :first

    assert_text "Teaching was successfully destroyed"
  end
end
