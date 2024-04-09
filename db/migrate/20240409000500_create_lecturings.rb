class CreateLecturings < ActiveRecord::Migration[7.1]
  def change
    create_table :lecturings do |t|
      t.references :course, null: false, foreign_key: true
      t.references :teacher, null: false, foreign_key: true

      t.timestamps
    end
  end
end
