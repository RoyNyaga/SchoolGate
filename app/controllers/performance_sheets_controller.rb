class PerformanceSheetsController < InheritedResources::Base

  private

    def performance_sheet_params
      params.require(:performance_sheet).permit(:school_id, :academic_year_id, :teacher_id, :school_class_id, :term_id, :seq_num, :processing_time)
    end

end
