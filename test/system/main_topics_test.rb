require "application_system_test_case"

class MainTopicsTest < ApplicationSystemTestCase
  setup do
    @main_topic = main_topics(:one)
  end

  test "visiting the index" do
    visit main_topics_url
    assert_selector "h1", text: "Main topics"
  end

  test "should create main topic" do
    visit main_topics_url
    click_on "New main topic"

    fill_in "Curriculum", with: @main_topic.curriculum_id
    check "Is complete" if @main_topic.is_complete
    fill_in "Teacher", with: @main_topic.teacher_id
    fill_in "Title", with: @main_topic.title
    click_on "Create Main topic"

    assert_text "Main topic was successfully created"
    click_on "Back"
  end

  test "should update Main topic" do
    visit main_topic_url(@main_topic)
    click_on "Edit this main topic", match: :first

    fill_in "Curriculum", with: @main_topic.curriculum_id
    check "Is complete" if @main_topic.is_complete
    fill_in "Teacher", with: @main_topic.teacher_id
    fill_in "Title", with: @main_topic.title
    click_on "Update Main topic"

    assert_text "Main topic was successfully updated"
    click_on "Back"
  end

  test "should destroy Main topic" do
    visit main_topic_url(@main_topic)
    click_on "Destroy this main topic", match: :first

    assert_text "Main topic was successfully destroyed"
  end
end
