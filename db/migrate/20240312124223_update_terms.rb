class UpdateTerms < ActiveRecord::Migration[7.1]
  def change
    remove_column :terms, :academic_year, :string
    add_reference :terms, :academic_year, foreign_key: true
  end
end
