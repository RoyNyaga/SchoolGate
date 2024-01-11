class AddSchoolFeesSettingsToSchool < ActiveRecord::Migration[7.1]
  def change
    add_column :schools, :school_fees_settings, :json, default: {}
  end
end
