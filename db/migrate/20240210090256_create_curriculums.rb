class CreateCurriculums < ActiveRecord::Migration[7.1]
  def change
    create_table :curriculums do |t|
      t.references :school, null: false, foreign_key: true
      t.references :school_class, null: false, foreign_key: true
      t.references :teacher, null: false, foreign_key: true
      t.references :subject, null: false, foreign_key: true
      t.string :title
      t.string :is_complete
      t.float :percent_complete

      t.timestamps
    end
  end
end
