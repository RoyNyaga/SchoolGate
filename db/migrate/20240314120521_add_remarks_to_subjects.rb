class AddRemarksToSubjects < ActiveRecord::Migration[7.1]
  def change
    add_column :subjects, :remarks, :jsonb, default: { "less_than_equal_to_5" => "Very poor",
                                                       "less_than_equal_to_9" => "Poor",
                                                       "less_than_equal_to_12" => "Average",
                                                       "less_than_equal_to_15" => "Good",
                                                       "less_than_equal_to_18" => "V good",
                                                       "less_than_equal_to_20" => "Excellent" }
  end
end
