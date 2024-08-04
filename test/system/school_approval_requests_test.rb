require "application_system_test_case"

class SchoolApprovalRequestsTest < ApplicationSystemTestCase
  setup do
    @school_approval_request = school_approval_requests(:one)
  end

  test "visiting the index" do
    visit school_approval_requests_url
    assert_selector "h1", text: "School approval requests"
  end

  test "should create school approval request" do
    visit school_approval_requests_url
    click_on "New school approval request"

    fill_in "Address", with: @school_approval_request.address
    fill_in "Education level", with: @school_approval_request.education_level
    fill_in "How did you know about us", with: @school_approval_request.how_did_you_know_about_us
    fill_in "Num of student", with: @school_approval_request.num_of_student
    fill_in "School", with: @school_approval_request.school_id
    fill_in "School name", with: @school_approval_request.school_name
    fill_in "Teacher", with: @school_approval_request.teacher_id
    fill_in "Town", with: @school_approval_request.town
    fill_in "Why schoolgate", with: @school_approval_request.why_schoolgate
    click_on "Create School approval request"

    assert_text "School approval request was successfully created"
    click_on "Back"
  end

  test "should update School approval request" do
    visit school_approval_request_url(@school_approval_request)
    click_on "Edit this school approval request", match: :first

    fill_in "Address", with: @school_approval_request.address
    fill_in "Education level", with: @school_approval_request.education_level
    fill_in "How did you know about us", with: @school_approval_request.how_did_you_know_about_us
    fill_in "Num of student", with: @school_approval_request.num_of_student
    fill_in "School", with: @school_approval_request.school_id
    fill_in "School name", with: @school_approval_request.school_name
    fill_in "Teacher", with: @school_approval_request.teacher_id
    fill_in "Town", with: @school_approval_request.town
    fill_in "Why schoolgate", with: @school_approval_request.why_schoolgate
    click_on "Update School approval request"

    assert_text "School approval request was successfully updated"
    click_on "Back"
  end

  test "should destroy School approval request" do
    visit school_approval_request_url(@school_approval_request)
    click_on "Destroy this school approval request", match: :first

    assert_text "School approval request was successfully destroyed"
  end
end
