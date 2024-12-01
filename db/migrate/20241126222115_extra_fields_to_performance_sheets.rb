class ExtraFieldsToPerformanceSheets < ActiveRecord::Migration[7.1]
  def change
    add_column :performance_sheets, :student_num, :integer
    add_column :performance_sheets, :passed_student_num, :integer
    add_column :performance_sheets, :performance_data, :text, array: true, default: []
    add_column :performance_sheets, :category, :integer
  end
end
