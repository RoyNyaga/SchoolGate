require "application_system_test_case"

class DepositsTest < ApplicationSystemTestCase
  setup do
    @deposit = deposits(:one)
  end

  test "visiting the index" do
    visit deposits_url
    assert_selector "h1", text: "Deposits"
  end

  test "should create deposit" do
    visit deposits_url
    click_on "New deposit"

    fill_in "Amount", with: @deposit.amount
    fill_in "Approval", with: @deposit.approval
    fill_in "Description", with: @deposit.description
    fill_in "Origin", with: @deposit.origin
    fill_in "School", with: @deposit.school_id
    fill_in "Teacher", with: @deposit.teacher_id
    click_on "Create Deposit"

    assert_text "Deposit was successfully created"
    click_on "Back"
  end

  test "should update Deposit" do
    visit deposit_url(@deposit)
    click_on "Edit this deposit", match: :first

    fill_in "Amount", with: @deposit.amount
    fill_in "Approval", with: @deposit.approval
    fill_in "Description", with: @deposit.description
    fill_in "Origin", with: @deposit.origin
    fill_in "School", with: @deposit.school_id
    fill_in "Teacher", with: @deposit.teacher_id
    click_on "Update Deposit"

    assert_text "Deposit was successfully updated"
    click_on "Back"
  end

  test "should destroy Deposit" do
    visit deposit_url(@deposit)
    click_on "Destroy this deposit", match: :first

    assert_text "Deposit was successfully destroyed"
  end
end
