require "test_helper"

class ReportCardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @report_card = report_cards(:one)
  end

  test "should get index" do
    get report_cards_url
    assert_response :success
  end

  test "should get new" do
    get new_report_card_url
    assert_response :success
  end

  test "should create report_card" do
    assert_difference("ReportCard.count") do
      post report_cards_url, params: { report_card: { average: @report_card.average, class_average: @report_card.class_average, passed_subjects: @report_card.passed_subjects, rank: @report_card.rank, school_class_id: @report_card.school_class_id, school_id: @report_card.school_id, term_id: @report_card.term_id } }
    end

    assert_redirected_to report_card_url(ReportCard.last)
  end

  test "should show report_card" do
    get report_card_url(@report_card)
    assert_response :success
  end

  test "should get edit" do
    get edit_report_card_url(@report_card)
    assert_response :success
  end

  test "should update report_card" do
    patch report_card_url(@report_card), params: { report_card: { average: @report_card.average, class_average: @report_card.class_average, passed_subjects: @report_card.passed_subjects, rank: @report_card.rank, school_class_id: @report_card.school_class_id, school_id: @report_card.school_id, term_id: @report_card.term_id } }
    assert_redirected_to report_card_url(@report_card)
  end

  test "should destroy report_card" do
    assert_difference("ReportCard.count", -1) do
      delete report_card_url(@report_card)
    end

    assert_redirected_to report_cards_url
  end
end
