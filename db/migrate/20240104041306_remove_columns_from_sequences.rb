class RemoveColumnsFromSequences < ActiveRecord::Migration[7.1]
  def change
    remove_column :sequences, :academic_year_start, :string
    remove_column :sequences, :academic_year_end, :string
  end
end
