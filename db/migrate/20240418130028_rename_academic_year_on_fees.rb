class RenameAcademicYearOnFees < ActiveRecord::Migration[7.1]
  def change
    rename_column :fees, :academic_year, :academic_year_text
    add_reference :fees, :academic_year, null: true, foreign_key: true
  end
end
