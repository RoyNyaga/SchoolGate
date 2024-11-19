require "application_system_test_case"

class PerformanceSheetsTest < ApplicationSystemTestCase
  setup do
    @performance_sheet = performance_sheets(:one)
  end

  test "visiting the index" do
    visit performance_sheets_url
    assert_selector "h1", text: "Performance sheets"
  end

  test "should create performance sheet" do
    visit performance_sheets_url
    click_on "New performance sheet"

    fill_in "Academic year", with: @performance_sheet.academic_year_id
    fill_in "Processing time", with: @performance_sheet.processing_time
    fill_in "School class", with: @performance_sheet.school_class_id
    fill_in "School", with: @performance_sheet.school_id
    fill_in "Seq num", with: @performance_sheet.seq_num
    fill_in "Teacher", with: @performance_sheet.teacher_id
    fill_in "Term", with: @performance_sheet.term_id
    click_on "Create Performance sheet"

    assert_text "Performance sheet was successfully created"
    click_on "Back"
  end

  test "should update Performance sheet" do
    visit performance_sheet_url(@performance_sheet)
    click_on "Edit this performance sheet", match: :first

    fill_in "Academic year", with: @performance_sheet.academic_year_id
    fill_in "Processing time", with: @performance_sheet.processing_time
    fill_in "School class", with: @performance_sheet.school_class_id
    fill_in "School", with: @performance_sheet.school_id
    fill_in "Seq num", with: @performance_sheet.seq_num
    fill_in "Teacher", with: @performance_sheet.teacher_id
    fill_in "Term", with: @performance_sheet.term_id
    click_on "Update Performance sheet"

    assert_text "Performance sheet was successfully updated"
    click_on "Back"
  end

  test "should destroy Performance sheet" do
    visit performance_sheet_url(@performance_sheet)
    click_on "Destroy this performance sheet", match: :first

    assert_text "Performance sheet was successfully destroyed"
  end
end
