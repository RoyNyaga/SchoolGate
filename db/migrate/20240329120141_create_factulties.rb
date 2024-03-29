class CreateFactulties < ActiveRecord::Migration[7.1]
  def change
    create_table :factulties do |t|
      t.references :school, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
