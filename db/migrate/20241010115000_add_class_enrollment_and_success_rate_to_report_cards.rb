class AddClassEnrollmentAndSuccessRateToReportCards < ActiveRecord::Migration[7.1]
  def change
    add_column :report_cards, :class_enrollment, :integer
    add_column :report_cards, :success_rate, :float
  end
end
