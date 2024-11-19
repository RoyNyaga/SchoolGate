class CreatePerformanceSheets < ActiveRecord::Migration[7.1]
  def change
    create_table :performance_sheets do |t|
      t.references :school, null: false, foreign_key: true
      t.references :academic_year, null: false, foreign_key: true
      t.references :teacher, null: false, foreign_key: true
      t.references :school_class, null: false, foreign_key: true
      t.references :term, null: false, foreign_key: true
      t.integer :seq_num, null: true
      t.string :processing_time

      t.timestamps
    end
  end
end
