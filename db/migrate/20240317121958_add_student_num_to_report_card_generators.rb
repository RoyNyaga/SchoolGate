class AddStudentNumToReportCardGenerators < ActiveRecord::Migration[7.1]
  def change
    add_column :report_card_generators, :student_num, :integer
  end
end
