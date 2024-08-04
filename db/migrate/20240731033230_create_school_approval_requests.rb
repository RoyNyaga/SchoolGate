class CreateSchoolApprovalRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :school_approval_requests do |t|
      t.references :school, null: false, foreign_key: true
      t.references :teacher, null: false, foreign_key: true
      t.string :school_name
      t.integer :num_of_student
      t.string :education_level
      t.string :why_schoolgate
      t.string :town
      t.string :address
      t.string :how_did_you_know_about_us
      t.integer :approval_state, default: 1

      t.timestamps
    end
  end
end
