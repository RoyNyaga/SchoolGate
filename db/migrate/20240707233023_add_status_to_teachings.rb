class AddStatusToTeachings < ActiveRecord::Migration[7.1]
  def change
    add_column :teachings, :status, :boolean, default: true
  end
end
