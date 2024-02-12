class CreateTopics < ActiveRecord::Migration[7.1]
  def change
    create_table :topics do |t|
      t.references :teacher, null: false, foreign_key: true
      t.references :main_topic, null: false, foreign_key: true
      t.string :title, null: false
      t.integer :progress, default: 1

      t.timestamps
    end
  end
end
