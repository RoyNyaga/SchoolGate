class PerformanceSheetsController < ApplicationController
  layout "school_layout"
  before_action :check_for_current_school
  skip_before_action :authenticate_teacher!
  before_action :set_performance_sheet, only: [:show, :regenerate, :download]

  def show
  end

  def new
  end

  def edit
  end

  def create
    @performance_sheet = PerformanceSheet.new(performance_sheet_params)
    if @performance_sheet.save
      flash[:success] = "Successfully generated performance Sheet"

      redirect_to performance_sheet_url(@performance_sheet)
    else
      render :new
    end
  end

  def regenerate
    @performance_sheet.teacher_id = current_teacher.id
    if @performance_sheet.save
      flash[:success] = "Successfully Regenerated"
      redirect_to performance_sheet_url(@performance_sheet)
    else
      render :edit
    end
  end

  def download
    pdf = @performance_sheet.generate_sheet
    respond_to do |format|
      format.html # regular HTML response
      format.pdf do
        send_data pdf.render, filename: "receipt.pdf",
                              type: "application/pdf",
                              disposition: "inline" # or 'attachment' to force download
      end
    end
  end

  private

  def set_performance_sheet
    @performance_sheet = PerformanceSheet.find_by(id: params[:id])
  end

  def performance_sheet_params
    params.require(:performance_sheet).permit(:school_id, :academic_year_id, :teacher_id, :school_class_id, :term_id, :seq_num, :category)
  end
end
