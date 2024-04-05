require "test_helper"

class FacultiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @faculty = factulties(:one)
  end

  test "should get index" do
    get factulties_url
    assert_response :success
  end

  test "should get new" do
    get new_factulty_url
    assert_response :success
  end

  test "should create faculty" do
    assert_difference("Factulty.count") do
      post factulties_url, params: { faculty: { name: @faculty.name, school_id: @faculty.school_id } }
    end

    assert_redirected_to factulty_url(Factulty.last)
  end

  test "should show faculty" do
    get factulty_url(@faculty)
    assert_response :success
  end

  test "should get edit" do
    get edit_factulty_url(@faculty)
    assert_response :success
  end

  test "should update faculty" do
    patch factulty_url(@faculty), params: { faculty: { name: @faculty.name, school_id: @faculty.school_id } }
    assert_redirected_to factulty_url(@faculty)
  end

  test "should destroy faculty" do
    assert_difference("Factulty.count", -1) do
      delete factulty_url(@faculty)
    end

    assert_redirected_to factulties_url
  end
end
