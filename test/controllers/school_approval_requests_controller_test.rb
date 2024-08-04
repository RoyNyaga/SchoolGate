require "test_helper"

class SchoolApprovalRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @school_approval_request = school_approval_requests(:one)
  end

  test "should get index" do
    get school_approval_requests_url
    assert_response :success
  end

  test "should get new" do
    get new_school_approval_request_url
    assert_response :success
  end

  test "should create school_approval_request" do
    assert_difference("SchoolApprovalRequest.count") do
      post school_approval_requests_url, params: { school_approval_request: { address: @school_approval_request.address, education_level: @school_approval_request.education_level, how_did_you_know_about_us: @school_approval_request.how_did_you_know_about_us, num_of_student: @school_approval_request.num_of_student, school_id: @school_approval_request.school_id, school_name: @school_approval_request.school_name, teacher_id: @school_approval_request.teacher_id, town: @school_approval_request.town, why_schoolgate: @school_approval_request.why_schoolgate } }
    end

    assert_redirected_to school_approval_request_url(SchoolApprovalRequest.last)
  end

  test "should show school_approval_request" do
    get school_approval_request_url(@school_approval_request)
    assert_response :success
  end

  test "should get edit" do
    get edit_school_approval_request_url(@school_approval_request)
    assert_response :success
  end

  test "should update school_approval_request" do
    patch school_approval_request_url(@school_approval_request), params: { school_approval_request: { address: @school_approval_request.address, education_level: @school_approval_request.education_level, how_did_you_know_about_us: @school_approval_request.how_did_you_know_about_us, num_of_student: @school_approval_request.num_of_student, school_id: @school_approval_request.school_id, school_name: @school_approval_request.school_name, teacher_id: @school_approval_request.teacher_id, town: @school_approval_request.town, why_schoolgate: @school_approval_request.why_schoolgate } }
    assert_redirected_to school_approval_request_url(@school_approval_request)
  end

  test "should destroy school_approval_request" do
    assert_difference("SchoolApprovalRequest.count", -1) do
      delete school_approval_request_url(@school_approval_request)
    end

    assert_redirected_to school_approval_requests_url
  end
end
