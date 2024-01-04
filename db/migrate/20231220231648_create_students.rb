class CreateStudents < ActiveRecord::Migration[7.1]
  def change
    create_table :students do |t|
      t.references :school, null: false, foreign_key: true
      t.references :school_class, null: false, foreign_key: true
      t.string :full_name
      t.string :fathers_name
      t.string :fathers_contact
      t.string :mothers_name
      t.string :mothers_contact
      t.string :guidance_name
      t.string :guidance_contact
      t.date :date_of_birth
      t.string :address
      t.string :subjects

      t.timestamps
    end
  end
end
