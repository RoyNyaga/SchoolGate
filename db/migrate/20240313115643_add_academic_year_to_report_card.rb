class AddAcademicYearToReportCard < ActiveRecord::Migration[7.1]
  def change
    add_reference :report_cards, :academic_year, null: false, foreign_key: true
  end
end
