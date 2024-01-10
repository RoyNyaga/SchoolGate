require "test_helper"

class FeesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @fee = fees(:one)
  end

  test "should get index" do
    get fees_url
    assert_response :success
  end

  test "should get new" do
    get new_fee_url
    assert_response :success
  end

  test "should create fee" do
    assert_difference("Fee.count") do
      post fees_url, params: { fee: { academic_year_end: @fee.academic_year_end, academic_year_start: @fee.academic_year_start, installment_num: @fee.installment_num, installments: @fee.installments, is_completed: @fee.is_completed, school_class_id: @fee.school_class_id, school_id: @fee.school_id, student_id: @fee.student_id, teacher_id: @fee.teacher_id, total_feee_paid: @fee.total_feee_paid } }
    end

    assert_redirected_to fee_url(Fee.last)
  end

  test "should show fee" do
    get fee_url(@fee)
    assert_response :success
  end

  test "should get edit" do
    get edit_fee_url(@fee)
    assert_response :success
  end

  test "should update fee" do
    patch fee_url(@fee), params: { fee: { academic_year_end: @fee.academic_year_end, academic_year_start: @fee.academic_year_start, installment_num: @fee.installment_num, installments: @fee.installments, is_completed: @fee.is_completed, school_class_id: @fee.school_class_id, school_id: @fee.school_id, student_id: @fee.student_id, teacher_id: @fee.teacher_id, total_feee_paid: @fee.total_feee_paid } }
    assert_redirected_to fee_url(@fee)
  end

  test "should destroy fee" do
    assert_difference("Fee.count", -1) do
      delete fee_url(@fee)
    end

    assert_redirected_to fees_url
  end
end
