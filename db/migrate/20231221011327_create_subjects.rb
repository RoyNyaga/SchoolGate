class CreateSubjects < ActiveRecord::Migration[7.1]
  def change
    create_table :subjects do |t|
      t.references :school, null: false, foreign_key: true
      t.references :school_class, null: false, foreign_key: true
      t.string :name, null: false
      t.float :coefficient, null: false

      t.timestamps
    end
  end
end
