class CreateProprietorQues < ActiveRecord::Migration[7.1]
  def change
    create_table :proprietor_ques do |t|
      t.string :full_name
      t.string :phone_number
      t.string :name_of_school
      t.string :location
      t.jsonb :functionality_importance, default: {}
      t.string :additional_features
      t.string :cost
      t.boolean :should_join_community, default: false
      t.string :education_level
      t.string :keeping_track_of_school_fees
      t.jsonb :other_questions, default: {}

      t.timestamps
    end
  end
end
