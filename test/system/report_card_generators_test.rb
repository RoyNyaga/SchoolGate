require "application_system_test_case"

class ReportCardGeneratorsTest < ApplicationSystemTestCase
  setup do
    @report_card_generator = report_card_generators(:one)
  end

  test "visiting the index" do
    visit report_card_generators_url
    assert_selector "h1", text: "Report card generators"
  end

  test "should create report card generator" do
    visit report_card_generators_url
    click_on "New report card generator"

    fill_in "Academic year", with: @report_card_generator.academic_year_id
    fill_in "Class average", with: @report_card_generator.class_average
    fill_in "Failed errors", with: @report_card_generator.failed_errors
    fill_in "Most performed students", with: @report_card_generator.most_performed_students
    fill_in "School class", with: @report_card_generator.school_class_id
    fill_in "School", with: @report_card_generator.school_id
    fill_in "Status", with: @report_card_generator.status
    fill_in "Student passed num", with: @report_card_generator.student_passed_num
    fill_in "Term", with: @report_card_generator.term_id
    click_on "Create Report card generator"

    assert_text "Report card generator was successfully created"
    click_on "Back"
  end

  test "should update Report card generator" do
    visit report_card_generator_url(@report_card_generator)
    click_on "Edit this report card generator", match: :first

    fill_in "Academic year", with: @report_card_generator.academic_year_id
    fill_in "Class average", with: @report_card_generator.class_average
    fill_in "Failed errors", with: @report_card_generator.failed_errors
    fill_in "Most performed students", with: @report_card_generator.most_performed_students
    fill_in "School class", with: @report_card_generator.school_class_id
    fill_in "School", with: @report_card_generator.school_id
    fill_in "Status", with: @report_card_generator.status
    fill_in "Student passed num", with: @report_card_generator.student_passed_num
    fill_in "Term", with: @report_card_generator.term_id
    click_on "Update Report card generator"

    assert_text "Report card generator was successfully updated"
    click_on "Back"
  end

  test "should destroy Report card generator" do
    visit report_card_generator_url(@report_card_generator)
    click_on "Destroy this report card generator", match: :first

    assert_text "Report card generator was successfully destroyed"
  end
end
