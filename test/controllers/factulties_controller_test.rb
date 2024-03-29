require "test_helper"

class FactultiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @factulty = factulties(:one)
  end

  test "should get index" do
    get factulties_url
    assert_response :success
  end

  test "should get new" do
    get new_factulty_url
    assert_response :success
  end

  test "should create factulty" do
    assert_difference("Factulty.count") do
      post factulties_url, params: { factulty: { name: @factulty.name, school_id: @factulty.school_id } }
    end

    assert_redirected_to factulty_url(Factulty.last)
  end

  test "should show factulty" do
    get factulty_url(@factulty)
    assert_response :success
  end

  test "should get edit" do
    get edit_factulty_url(@factulty)
    assert_response :success
  end

  test "should update factulty" do
    patch factulty_url(@factulty), params: { factulty: { name: @factulty.name, school_id: @factulty.school_id } }
    assert_redirected_to factulty_url(@factulty)
  end

  test "should destroy factulty" do
    assert_difference("Factulty.count", -1) do
      delete factulty_url(@factulty)
    end

    assert_redirected_to factulties_url
  end
end
