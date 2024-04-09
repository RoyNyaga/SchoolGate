require "test_helper"

class LecturingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lecturing = lecturings(:one)
  end

  test "should get index" do
    get lecturings_url
    assert_response :success
  end

  test "should get new" do
    get new_lecturing_url
    assert_response :success
  end

  test "should create lecturing" do
    assert_difference("Lecturing.count") do
      post lecturings_url, params: { lecturing: { course_id: @lecturing.course_id, teacher_id: @lecturing.teacher_id } }
    end

    assert_redirected_to lecturing_url(Lecturing.last)
  end

  test "should show lecturing" do
    get lecturing_url(@lecturing)
    assert_response :success
  end

  test "should get edit" do
    get edit_lecturing_url(@lecturing)
    assert_response :success
  end

  test "should update lecturing" do
    patch lecturing_url(@lecturing), params: { lecturing: { course_id: @lecturing.course_id, teacher_id: @lecturing.teacher_id } }
    assert_redirected_to lecturing_url(@lecturing)
  end

  test "should destroy lecturing" do
    assert_difference("Lecturing.count", -1) do
      delete lecturing_url(@lecturing)
    end

    assert_redirected_to lecturings_url
  end
end
