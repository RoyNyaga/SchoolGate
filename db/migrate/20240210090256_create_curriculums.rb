class CreateCurriculums < ActiveRecord::Migration[7.1]
  def change
    create_table :curriculums do |t|
      t.references :school, null: false, foreign_key: true
      t.references :school_class, null: false, foreign_key: true
      t.references :teacher, null: false, foreign_key: true
      t.references :subject, null: false, foreign_key: true
      t.string :title
      t.string :is_complete, default: false
      t.float :percent_complete, default: 0.00
      t.string :academic_year, null: false
      t.timestamps
    end
  end
end
