class CreateInvitations < ActiveRecord::Migration[7.1]
  def change
    create_table :invitations do |t|
      t.references :sender, null: false
      t.references :teacher, null: false, foreign_key: true
      t.references :school, null: false, foreign_key: true
      t.integer :permission, default: 0 #teacher
      t.float :proposed_salary, default: 0
      t.text :job_description
      t.integer :status, default: 0 #pending

      t.timestamps
    end
  end
end
