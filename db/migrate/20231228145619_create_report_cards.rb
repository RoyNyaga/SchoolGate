class CreateReportCards < ActiveRecord::Migration[7.1]
  def change
    create_table :report_cards do |t|
      t.references :school, null: false, foreign_key: true
      t.references :school_class, null: false, foreign_key: true
      t.references :term, null: false, foreign_key: true
      t.float :average
      t.integer :rank
      t.integer :class_average
      t.integer :passed_subjects
      t.text :details, array: true, default: []

      t.timestamps
    end
  end
end
