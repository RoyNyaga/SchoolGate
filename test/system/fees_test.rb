require "application_system_test_case"

class FeesTest < ApplicationSystemTestCase
  setup do
    @fee = fees(:one)
  end

  test "visiting the index" do
    visit fees_url
    assert_selector "h1", text: "Fees"
  end

  test "should create fee" do
    visit fees_url
    click_on "New fee"

    fill_in "Academic year end", with: @fee.academic_year_end
    fill_in "Academic year start", with: @fee.academic_year_start
    fill_in "Installment num", with: @fee.installment_num
    fill_in "Installments", with: @fee.installments
    check "Is completed" if @fee.is_completed
    fill_in "School class", with: @fee.school_class_id
    fill_in "School", with: @fee.school_id
    fill_in "Student", with: @fee.student_id
    fill_in "Teacher", with: @fee.teacher_id
    fill_in "Total feee paid", with: @fee.total_feee_paid
    click_on "Create Fee"

    assert_text "Fee was successfully created"
    click_on "Back"
  end

  test "should update Fee" do
    visit fee_url(@fee)
    click_on "Edit this fee", match: :first

    fill_in "Academic year end", with: @fee.academic_year_end
    fill_in "Academic year start", with: @fee.academic_year_start
    fill_in "Installment num", with: @fee.installment_num
    fill_in "Installments", with: @fee.installments
    check "Is completed" if @fee.is_completed
    fill_in "School class", with: @fee.school_class_id
    fill_in "School", with: @fee.school_id
    fill_in "Student", with: @fee.student_id
    fill_in "Teacher", with: @fee.teacher_id
    fill_in "Total feee paid", with: @fee.total_feee_paid
    click_on "Update Fee"

    assert_text "Fee was successfully updated"
    click_on "Back"
  end

  test "should destroy Fee" do
    visit fee_url(@fee)
    click_on "Destroy this fee", match: :first

    assert_text "Fee was successfully destroyed"
  end
end
