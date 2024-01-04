class AddStudentIdToReportCards < ActiveRecord::Migration[7.1]
  def change
    add_reference :report_cards, :student, null: false, foreign_key: true
  end
end
