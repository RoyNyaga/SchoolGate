require "test_helper"

class CourseResultsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @course_result = course_results(:one)
  end

  test "should get index" do
    get course_results_url
    assert_response :success
  end

  test "should get new" do
    get new_course_result_url
    assert_response :success
  end

  test "should create course_result" do
    assert_difference("CourseResult.count") do
      post course_results_url, params: { course_result: { academic_year_id: @course_result.academic_year_id, ca_mark: @course_result.ca_mark, course_id: @course_result.course_id, credit_val: @course_result.credit_val, exam_mark: @course_result.exam_mark, has_resit: @course_result.has_resit, is_validated: @course_result.is_validated, resit_mark: @course_result.resit_mark, school_id: @course_result.school_id, semester_id: @course_result.semester_id, student_id: @course_result.student_id, total_mark: @course_result.total_mark } }
    end

    assert_redirected_to course_result_url(CourseResult.last)
  end

  test "should show course_result" do
    get course_result_url(@course_result)
    assert_response :success
  end

  test "should get edit" do
    get edit_course_result_url(@course_result)
    assert_response :success
  end

  test "should update course_result" do
    patch course_result_url(@course_result), params: { course_result: { academic_year_id: @course_result.academic_year_id, ca_mark: @course_result.ca_mark, course_id: @course_result.course_id, credit_val: @course_result.credit_val, exam_mark: @course_result.exam_mark, has_resit: @course_result.has_resit, is_validated: @course_result.is_validated, resit_mark: @course_result.resit_mark, school_id: @course_result.school_id, semester_id: @course_result.semester_id, student_id: @course_result.student_id, total_mark: @course_result.total_mark } }
    assert_redirected_to course_result_url(@course_result)
  end

  test "should destroy course_result" do
    assert_difference("CourseResult.count", -1) do
      delete course_result_url(@course_result)
    end

    assert_redirected_to course_results_url
  end
end
