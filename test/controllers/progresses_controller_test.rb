require "test_helper"

class ProgressesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @progress = progresses(:one)
  end

  test "should get index" do
    get progresses_url
    assert_response :success
  end

  test "should get new" do
    get new_progress_url
    assert_response :success
  end

  test "should create progress" do
    assert_difference("Progress.count") do
      post progresses_url, params: { progress: { absent_student_ids: @progress.absent_student_ids, academic_year: @progress.academic_year, duration: @progress.duration, school_id: @progress.school_id, seq_num: @progress.seq_num, subject_id: @progress.subject_id, teacher_id: @progress.teacher_id, term_id: @progress.term_id, topics: @progress.topics } }
    end

    assert_redirected_to progress_url(Progress.last)
  end

  test "should show progress" do
    get progress_url(@progress)
    assert_response :success
  end

  test "should get edit" do
    get edit_progress_url(@progress)
    assert_response :success
  end

  test "should update progress" do
    patch progress_url(@progress), params: { progress: { absent_student_ids: @progress.absent_student_ids, academic_year: @progress.academic_year, duration: @progress.duration, school_id: @progress.school_id, seq_num: @progress.seq_num, subject_id: @progress.subject_id, teacher_id: @progress.teacher_id, term_id: @progress.term_id, topics: @progress.topics } }
    assert_redirected_to progress_url(@progress)
  end

  test "should destroy progress" do
    assert_difference("Progress.count", -1) do
      delete progress_url(@progress)
    end

    assert_redirected_to progresses_url
  end
end
