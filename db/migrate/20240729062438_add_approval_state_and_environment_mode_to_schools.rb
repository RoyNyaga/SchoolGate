class AddApprovalStateAndEnvironmentModeToSchools < ActiveRecord::Migration[7.1]
  def change
    add_column :schools, :approval_state, :integer, default: 0
    add_column :schools, :environment_mode, :integer, default: 0
  end
end
