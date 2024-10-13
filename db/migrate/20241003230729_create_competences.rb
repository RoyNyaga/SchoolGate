class CreateCompetences < ActiveRecord::Migration[7.1]
  def change
    create_table :competences do |t|
      t.references :school, null: false, foreign_key: true
      t.references :school_class, null: false, foreign_key: true
      t.references :subject, null: false, foreign_key: true
      t.string :title

      t.timestamps
    end
  end
end
