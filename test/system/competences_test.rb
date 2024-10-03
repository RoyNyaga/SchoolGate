require "application_system_test_case"

class CompetencesTest < ApplicationSystemTestCase
  setup do
    @competence = competences(:one)
  end

  test "visiting the index" do
    visit competences_url
    assert_selector "h1", text: "Competences"
  end

  test "should create competence" do
    visit competences_url
    click_on "New competence"

    fill_in "School class", with: @competence.school_class_id
    fill_in "School", with: @competence.school_id
    fill_in "subject", with: @competence.suubject_id
    fill_in "Title", with: @competence.title
    click_on "Create Competence"

    assert_text "Competence was successfully created"
    click_on "Back"
  end

  test "should update Competence" do
    visit competence_url(@competence)
    click_on "Edit this competence", match: :first

    fill_in "School class", with: @competence.school_class_id
    fill_in "School", with: @competence.school_id
    fill_in "subject", with: @competence.suubject_id
    fill_in "Title", with: @competence.title
    click_on "Update Competence"

    assert_text "Competence was successfully updated"
    click_on "Back"
  end

  test "should destroy Competence" do
    visit competence_url(@competence)
    click_on "Destroy this competence", match: :first

    assert_text "Competence was successfully destroyed"
  end
end
