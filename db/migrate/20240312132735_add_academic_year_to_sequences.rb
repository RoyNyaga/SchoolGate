class AddAcademicYearToSequences < ActiveRecord::Migration[7.1]
  def change
    add_reference :sequences, :academic_year, null: false, foreign_key: true
  end
end
