require "test_helper"

class PerformanceSheetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @performance_sheet = performance_sheets(:one)
  end

  test "should get index" do
    get performance_sheets_url
    assert_response :success
  end

  test "should get new" do
    get new_performance_sheet_url
    assert_response :success
  end

  test "should create performance_sheet" do
    assert_difference("PerformanceSheet.count") do
      post performance_sheets_url, params: { performance_sheet: { academic_year_id: @performance_sheet.academic_year_id, processing_time: @performance_sheet.processing_time, school_class_id: @performance_sheet.school_class_id, school_id: @performance_sheet.school_id, seq_num: @performance_sheet.seq_num, teacher_id: @performance_sheet.teacher_id, term_id: @performance_sheet.term_id } }
    end

    assert_redirected_to performance_sheet_url(PerformanceSheet.last)
  end

  test "should show performance_sheet" do
    get performance_sheet_url(@performance_sheet)
    assert_response :success
  end

  test "should get edit" do
    get edit_performance_sheet_url(@performance_sheet)
    assert_response :success
  end

  test "should update performance_sheet" do
    patch performance_sheet_url(@performance_sheet), params: { performance_sheet: { academic_year_id: @performance_sheet.academic_year_id, processing_time: @performance_sheet.processing_time, school_class_id: @performance_sheet.school_class_id, school_id: @performance_sheet.school_id, seq_num: @performance_sheet.seq_num, teacher_id: @performance_sheet.teacher_id, term_id: @performance_sheet.term_id } }
    assert_redirected_to performance_sheet_url(@performance_sheet)
  end

  test "should destroy performance_sheet" do
    assert_difference("PerformanceSheet.count", -1) do
      delete performance_sheet_url(@performance_sheet)
    end

    assert_redirected_to performance_sheets_url
  end
end
