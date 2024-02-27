class AddPercentCompleteToMainTopics < ActiveRecord::Migration[7.1]
  def change
    add_column :main_topics, :percent_complete, :float, default: 0.00
  end
end
