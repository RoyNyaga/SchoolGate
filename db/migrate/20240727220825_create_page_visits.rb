class CreatePageVisits < ActiveRecord::Migration[7.1]
  def change
    create_table :page_visits do |t|
      t.json :pages, default: {}

      t.timestamps
    end
  end
end
