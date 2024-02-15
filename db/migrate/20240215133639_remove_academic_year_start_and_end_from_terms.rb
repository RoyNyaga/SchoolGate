class RemoveAcademicYearStartAndEndFromTerms < ActiveRecord::Migration[7.1]
  def change
    remove_column :terms, :academic_year_start, :string
    remove_column :terms, :academic_year_end, :string
    add_column :terms, :academic_year, :string, null: false
  end
end
