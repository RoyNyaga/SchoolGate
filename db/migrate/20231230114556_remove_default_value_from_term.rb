class RemoveDefaultValueFromTerm < ActiveRecord::Migration[7.1]
  def change
    change_column_default :terms, :term_type, nil
  end
end
