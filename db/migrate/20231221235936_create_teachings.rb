class CreateTeachings < ActiveRecord::Migration[7.1]
  def change
    create_table :teachings do |t|
      t.references :teacher, null: false, foreign_key: true
      t.references :subject, null: false, foreign_key: true
      t.references :school_class, null: false, foreign_key: true
      t.boolean :is_class_master

      t.timestamps
    end
  end
end
