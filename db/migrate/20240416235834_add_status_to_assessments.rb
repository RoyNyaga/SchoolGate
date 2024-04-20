class AddStatusToAssessments < ActiveRecord::Migration[7.1]
  def change
    add_column :assessments, :status, :integer, default: 0
  end
end
