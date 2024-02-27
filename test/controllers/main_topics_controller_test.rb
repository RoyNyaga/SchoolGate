require "test_helper"

class MainTopicsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @main_topic = main_topics(:one)
  end

  test "should get index" do
    get main_topics_url
    assert_response :success
  end

  test "should get new" do
    get new_main_topic_url
    assert_response :success
  end

  test "should create main_topic" do
    assert_difference("MainTopic.count") do
      post main_topics_url, params: { main_topic: { curriculum_id: @main_topic.curriculum_id, is_complete: @main_topic.is_complete, teacher_id: @main_topic.teacher_id, title: @main_topic.title } }
    end

    assert_redirected_to main_topic_url(MainTopic.last)
  end

  test "should show main_topic" do
    get main_topic_url(@main_topic)
    assert_response :success
  end

  test "should get edit" do
    get edit_main_topic_url(@main_topic)
    assert_response :success
  end

  test "should update main_topic" do
    patch main_topic_url(@main_topic), params: { main_topic: { curriculum_id: @main_topic.curriculum_id, is_complete: @main_topic.is_complete, teacher_id: @main_topic.teacher_id, title: @main_topic.title } }
    assert_redirected_to main_topic_url(@main_topic)
  end

  test "should destroy main_topic" do
    assert_difference("MainTopic.count", -1) do
      delete main_topic_url(@main_topic)
    end

    assert_redirected_to main_topics_url
  end
end
