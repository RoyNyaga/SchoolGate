class AddIdSettingsToSchools < ActiveRecord::Migration[7.1]
  def change
    add_column :schools, :student_id_settings, :jsonb
  end
end
