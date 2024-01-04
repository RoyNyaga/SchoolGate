require "application_system_test_case"

class SequencesTest < ApplicationSystemTestCase
  setup do
    @sequence = sequences(:one)
  end

  test "visiting the index" do
    visit sequences_url
    assert_selector "h1", text: "Sequences"
  end

  test "should create sequence" do
    visit sequences_url
    click_on "New sequence"

    fill_in "Academic year end", with: @sequence.academic_year_end
    fill_in "Academic year start", with: @sequence.academic_year_start
    fill_in "School class", with: @sequence.school_class_id
    fill_in "School", with: @sequence.school_id
    fill_in "Teacher", with: @sequence.teacher_id
    fill_in "Type", with: @sequence.seq_num
    click_on "Create Sequence"

    assert_text "Sequence was successfully created"
    click_on "Back"
  end

  test "should update Sequence" do
    visit sequence_url(@sequence)
    click_on "Edit this sequence", match: :first

    fill_in "Academic year end", with: @sequence.academic_year_end
    fill_in "Academic year start", with: @sequence.academic_year_start
    fill_in "School class", with: @sequence.school_class_id
    fill_in "School", with: @sequence.school_id
    fill_in "Teacher", with: @sequence.teacher_id
    fill_in "Type", with: @sequence.seq_num
    click_on "Update Sequence"

    assert_text "Sequence was successfully updated"
    click_on "Back"
  end

  test "should destroy Sequence" do
    visit sequence_url(@sequence)
    click_on "Destroy this sequence", match: :first

    assert_text "Sequence was successfully destroyed"
  end
end
