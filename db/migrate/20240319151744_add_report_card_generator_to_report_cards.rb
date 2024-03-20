class AddReportCardGeneratorToReportCards < ActiveRecord::Migration[7.1]
  def change
    add_reference :report_cards, :report_card_generator, null: false, foreign_key: true
  end
end
