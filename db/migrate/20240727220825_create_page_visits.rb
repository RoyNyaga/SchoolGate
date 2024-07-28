class CreatePageVisits < ActiveRecord::Migration[7.1]
  def change
    create_table :page_visits do |t|
      t.json :pages, default: {}
      t.integer :total_visit_count, default: 0
      t.timestamps
    end
  end
end
