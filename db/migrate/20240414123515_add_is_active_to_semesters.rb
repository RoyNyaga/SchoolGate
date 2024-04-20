class AddIsActiveToSemesters < ActiveRecord::Migration[7.1]
  def change
    add_column :semesters, :is_active, :boolean, default: false
  end
end
