class CompetencesController < InheritedResources::Base

  private

    def competence_params
      params.require(:competence).permit(:school_id, :school_class_id, :suubject_id, :title)
    end

end
