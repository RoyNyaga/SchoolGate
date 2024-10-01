class AddReportCardFormatEnumToSchools < ActiveRecord::Migration[7.1]
  def change
    add_column :schools, :report_card_format, :integer, default: 0
  end
end
