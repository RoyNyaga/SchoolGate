class CreateMainTopics < ActiveRecord::Migration[7.1]
  def change
    create_table :main_topics do |t|
      t.references :teacher, null: false, foreign_key: true
      t.references :curriculum, null: false, foreign_key: true
      t.references :subject, null: false, foreign_key: true
      t.string :title, null: false
      t.boolean :is_complete, default: false

      t.timestamps
    end
  end
end
