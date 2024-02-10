require "application_system_test_case"

class CurriculumsTest < ApplicationSystemTestCase
  setup do
    @curriculum = curriculums(:one)
  end

  test "visiting the index" do
    visit curriculums_url
    assert_selector "h1", text: "Curriculums"
  end

  test "should create curriculum" do
    visit curriculums_url
    click_on "New curriculum"

    fill_in "Is complete", with: @curriculum.is_complete
    fill_in "Percent complete", with: @curriculum.percent_complete
    fill_in "School class", with: @curriculum.school_class_id
    fill_in "School", with: @curriculum.school_id
    fill_in "Subject", with: @curriculum.subject_id
    fill_in "Teacher", with: @curriculum.teacher_id
    fill_in "Title", with: @curriculum.title
    click_on "Create Curriculum"

    assert_text "Curriculum was successfully created"
    click_on "Back"
  end

  test "should update Curriculum" do
    visit curriculum_url(@curriculum)
    click_on "Edit this curriculum", match: :first

    fill_in "Is complete", with: @curriculum.is_complete
    fill_in "Percent complete", with: @curriculum.percent_complete
    fill_in "School class", with: @curriculum.school_class_id
    fill_in "School", with: @curriculum.school_id
    fill_in "Subject", with: @curriculum.subject_id
    fill_in "Teacher", with: @curriculum.teacher_id
    fill_in "Title", with: @curriculum.title
    click_on "Update Curriculum"

    assert_text "Curriculum was successfully updated"
    click_on "Back"
  end

  test "should destroy Curriculum" do
    visit curriculum_url(@curriculum)
    click_on "Destroy this curriculum", match: :first

    assert_text "Curriculum was successfully destroyed"
  end
end
