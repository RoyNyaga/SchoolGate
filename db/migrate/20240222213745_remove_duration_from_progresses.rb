class RemoveDurationFromProgresses < ActiveRecord::Migration[7.1]
  def change
    add_column :progresses, :period_duration, :jsonb, default: { "hours" => 0, "mins" => 0 }
    remove_column :progresses, :duration, :time
  end
end
