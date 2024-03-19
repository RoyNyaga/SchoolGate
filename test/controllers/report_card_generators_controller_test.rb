require "test_helper"

class ReportCardGeneratorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @report_card_generator = report_card_generators(:one)
  end

  test "should get index" do
    get report_card_generators_url
    assert_response :success
  end

  test "should get new" do
    get new_report_card_generator_url
    assert_response :success
  end

  test "should create report_card_generator" do
    assert_difference("ReportCardGenerator.count") do
      post report_card_generators_url, params: { report_card_generator: { academic_year_id: @report_card_generator.academic_year_id, class_average: @report_card_generator.class_average, failed_errors: @report_card_generator.failed_errors, most_performed_students: @report_card_generator.most_performed_students, school_class_id: @report_card_generator.school_class_id, school_id: @report_card_generator.school_id, status: @report_card_generator.status, student_passed_num: @report_card_generator.student_passed_num, term_id: @report_card_generator.term_id } }
    end

    assert_redirected_to report_card_generator_url(ReportCardGenerator.last)
  end

  test "should show report_card_generator" do
    get report_card_generator_url(@report_card_generator)
    assert_response :success
  end

  test "should get edit" do
    get edit_report_card_generator_url(@report_card_generator)
    assert_response :success
  end

  test "should update report_card_generator" do
    patch report_card_generator_url(@report_card_generator), params: { report_card_generator: { academic_year_id: @report_card_generator.academic_year_id, class_average: @report_card_generator.class_average, failed_errors: @report_card_generator.failed_errors, most_performed_students: @report_card_generator.most_performed_students, school_class_id: @report_card_generator.school_class_id, school_id: @report_card_generator.school_id, status: @report_card_generator.status, student_passed_num: @report_card_generator.student_passed_num, term_id: @report_card_generator.term_id } }
    assert_redirected_to report_card_generator_url(@report_card_generator)
  end

  test "should destroy report_card_generator" do
    assert_difference("ReportCardGenerator.count", -1) do
      delete report_card_generator_url(@report_card_generator)
    end

    assert_redirected_to report_card_generators_url
  end
end
