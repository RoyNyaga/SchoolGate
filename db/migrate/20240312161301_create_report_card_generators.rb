class CreateReportCardGenerators < ActiveRecord::Migration[7.1]
  def change
    create_table :report_card_generators do |t|
      t.references :academic_year, null: false, foreign_key: true
      t.references :school_class, null: false, foreign_key: true
      t.references :term, null: false, foreign_key: true
      t.integer :student_passed_num
      t.float :class_average
      t.references :school, null: false, foreign_key: true
      t.integer :progress_state, default: 0
      t.boolean :is_successful, default: false
      t.text :failed_errors, array: true, default: []
      t.text :most_performed_students, array: true, default: []

      t.timestamps
    end
  end
end
