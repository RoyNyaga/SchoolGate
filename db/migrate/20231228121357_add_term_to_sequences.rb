class AddTermToSequences < ActiveRecord::Migration[7.1]
  def change
    add_reference :sequences, :term, null: true, foreign_key: true
  end
end
