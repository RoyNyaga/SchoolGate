class AddCompetenceToBeEvaluatedToSubjects < ActiveRecord::Migration[7.1]
  def change
    add_column :subjects, :competences_average, :integer, default: 20
    add_column :subjects, :competences, :text, array: true, default: []
  end
end
