class CreateTerms < ActiveRecord::Migration[7.1]
  def change
    create_table :terms do |t|
      t.references :school, null: false, foreign_key: true
      t.integer :term_type, default: 1, null: false
      t.string :academic_year_start
      t.string :academic_year_end

      t.timestamps
    end
  end
end
