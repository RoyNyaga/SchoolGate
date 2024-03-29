class AddEducationLevelToSchools < ActiveRecord::Migration[7.1]
  def change
    add_column :schools, :education_level, :integer, default: 1
  end
end
