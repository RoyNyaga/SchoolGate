class RenameUniqueIdentificationOnStudents < ActiveRecord::Migration[7.1]
  def change
    rename_column :students, :unique_identification, :matricule
  end
end
