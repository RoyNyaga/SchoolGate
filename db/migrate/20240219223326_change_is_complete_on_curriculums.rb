class ChangeIsCompleteOnCurriculums < ActiveRecord::Migration[7.1]
  def change
    remove_column :curriculums, :is_complete
    add_column :curriculums, :is_complete, :boolean, default: false
  end
end
