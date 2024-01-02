class ChangeAverageToFloatOnReportCards < ActiveRecord::Migration[7.1]
  def change
    change_column :report_cards, :class_average, :float
  end
end
