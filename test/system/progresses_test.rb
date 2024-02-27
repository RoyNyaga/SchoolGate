require "application_system_test_case"

class ProgressesTest < ApplicationSystemTestCase
  setup do
    @progress = progresses(:one)
  end

  test "visiting the index" do
    visit progresses_url
    assert_selector "h1", text: "Progresses"
  end

  test "should create progress" do
    visit progresses_url
    click_on "New progress"

    fill_in "Absent student ids", with: @progress.absent_student_ids
    fill_in "Academic year", with: @progress.academic_year
    fill_in "Duration", with: @progress.duration
    fill_in "School", with: @progress.school_id
    fill_in "Seq num", with: @progress.seq_num
    fill_in "Subject", with: @progress.subject_id
    fill_in "Teacher", with: @progress.teacher_id
    fill_in "Term", with: @progress.term_id
    fill_in "Topics", with: @progress.topics
    click_on "Create Progress"

    assert_text "Progress was successfully created"
    click_on "Back"
  end

  test "should update Progress" do
    visit progress_url(@progress)
    click_on "Edit this progress", match: :first

    fill_in "Absent student ids", with: @progress.absent_student_ids
    fill_in "Academic year", with: @progress.academic_year
    fill_in "Duration", with: @progress.duration
    fill_in "School", with: @progress.school_id
    fill_in "Seq num", with: @progress.seq_num
    fill_in "Subject", with: @progress.subject_id
    fill_in "Teacher", with: @progress.teacher_id
    fill_in "Term", with: @progress.term_id
    fill_in "Topics", with: @progress.topics
    click_on "Update Progress"

    assert_text "Progress was successfully updated"
    click_on "Back"
  end

  test "should destroy Progress" do
    visit progress_url(@progress)
    click_on "Destroy this progress", match: :first

    assert_text "Progress was successfully destroyed"
  end
end
