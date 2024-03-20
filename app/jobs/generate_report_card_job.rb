class GenerateReportCardJob < ApplicationJob
  queue_as :urgent

  def perform(report_card_generator_id)
    report_card_generator = ReportCardGenerator.find(report_card_generator_id)
    ReportCardGenerator.generate_school_class_report_cards(report_card_generator)
  end
end
