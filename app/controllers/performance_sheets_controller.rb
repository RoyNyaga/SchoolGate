class PerformanceSheetsController < ApplicationController
  def create
  end

  private

  def set_performance_sheet
    @performance_sheet = PerformanceSheet.find_by(id: params[:id])
  end

  def performance_sheet_params
    params.require(:performance_sheet).permit(:school_id, :academic_year_id, :teacher_id, :school_class_id, :term_id, :seq_num, :processing_time)
  end
end
