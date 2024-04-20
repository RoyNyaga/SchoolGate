require "application_system_test_case"

class ReceiptsTest < ApplicationSystemTestCase
  setup do
    @receipt = receipts(:one)
  end

  test "visiting the index" do
    visit receipts_url
    assert_selector "h1", text: "Receipts"
  end

  test "should create receipt" do
    visit receipts_url
    click_on "New receipt"

    fill_in "Academic year", with: @receipt.academic_year_id
    fill_in "Fee", with: @receipt.fee_id
    check "Has error" if @receipt.has_error
    fill_in "School", with: @receipt.school_id
    fill_in "Student", with: @receipt.student_id
    fill_in "Teacher", with: @receipt.teacher_id
    fill_in "Transaction reference", with: @receipt.transaction_reference
    click_on "Create Receipt"

    assert_text "Receipt was successfully created"
    click_on "Back"
  end

  test "should update Receipt" do
    visit receipt_url(@receipt)
    click_on "Edit this receipt", match: :first

    fill_in "Academic year", with: @receipt.academic_year_id
    fill_in "Fee", with: @receipt.fee_id
    check "Has error" if @receipt.has_error
    fill_in "School", with: @receipt.school_id
    fill_in "Student", with: @receipt.student_id
    fill_in "Teacher", with: @receipt.teacher_id
    fill_in "Transaction reference", with: @receipt.transaction_reference
    click_on "Update Receipt"

    assert_text "Receipt was successfully updated"
    click_on "Back"
  end

  test "should destroy Receipt" do
    visit receipt_url(@receipt)
    click_on "Destroy this receipt", match: :first

    assert_text "Receipt was successfully destroyed"
  end
end
