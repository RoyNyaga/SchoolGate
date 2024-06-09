class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.string :email
      t.string :phone_number
      t.string :phone_number_code
      t.string :country
      t.text :message

      t.timestamps
    end
  end
end
