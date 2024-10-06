class AddShouldEvaluateMultipleCompetencesPerSubjectToSchoolClasses < ActiveRecord::Migration[7.1]
  def change
    add_column :school_classes, :should_evaluate_multiple_competences_per_subject, :boolean, default: false
  end
end
