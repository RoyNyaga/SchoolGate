class AddReportCardFormatToSchoolClasses < ActiveRecord::Migration[7.1]
  def change
    add_column :school_classes, :report_card_format, :integer, default: 0
  end
end
