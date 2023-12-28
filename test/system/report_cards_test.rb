require "application_system_test_case"

class ReportCardsTest < ApplicationSystemTestCase
  setup do
    @report_card = report_cards(:one)
  end

  test "visiting the index" do
    visit report_cards_url
    assert_selector "h1", text: "Report cards"
  end

  test "should create report card" do
    visit report_cards_url
    click_on "New report card"

    fill_in "Average", with: @report_card.average
    fill_in "Class average", with: @report_card.class_average
    fill_in "Passed subjects", with: @report_card.passed_subjects
    fill_in "Rank", with: @report_card.rank
    fill_in "School class", with: @report_card.school_class_id
    fill_in "School", with: @report_card.school_id
    fill_in "Term", with: @report_card.term_id
    click_on "Create Report card"

    assert_text "Report card was successfully created"
    click_on "Back"
  end

  test "should update Report card" do
    visit report_card_url(@report_card)
    click_on "Edit this report card", match: :first

    fill_in "Average", with: @report_card.average
    fill_in "Class average", with: @report_card.class_average
    fill_in "Passed subjects", with: @report_card.passed_subjects
    fill_in "Rank", with: @report_card.rank
    fill_in "School class", with: @report_card.school_class_id
    fill_in "School", with: @report_card.school_id
    fill_in "Term", with: @report_card.term_id
    click_on "Update Report card"

    assert_text "Report card was successfully updated"
    click_on "Back"
  end

  test "should destroy Report card" do
    visit report_card_url(@report_card)
    click_on "Destroy this report card", match: :first

    assert_text "Report card was successfully destroyed"
  end
end
