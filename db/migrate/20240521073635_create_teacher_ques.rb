class CreateTeacherQues < ActiveRecord::Migration[7.1]
  def change
    create_table :teacher_ques do |t|
      t.string :full_name
      t.string :phone_number
      t.string :name_of_schools_taught
      t.string :location_of_schools
      t.string :education_level
      t.text :subjects_taught, array: true, default: []
      t.string :progress_importance
      t.text :most_usefull_feature, array: true, default: []
      t.string :comfort_in_filling_progress
      t.string :track_hours_usefulness
      t.string :online_report_cards
      t.jsonb :referal, default: {}

      t.timestamps
    end
  end
end
