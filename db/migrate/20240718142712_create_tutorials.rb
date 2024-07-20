class CreateTutorials < ActiveRecord::Migration[7.1]
  def change
    create_table :tutorials do |t|
      t.string :youtube_frame
      t.string :slug
      t.string :title
      t.integer :views
      t.integer :priority

      t.timestamps
    end
  end
end
