class ReportCardGeneratorsController < ApplicationController
  layout "school_layout"
  before_action :check_for_current_school
  before_action :set_report_card_generator, only: %i[ show edit update destroy loading progress_state_api ]

  # GET /report_card_generators or /report_card_generators.json
  def index
    @report_card_generators = current_school.report_card_generators.order(created_at: :desc)
  end

  # GET /report_card_generators/1 or /report_card_generators/1.json
  def show
  end

  # GET /report_card_generators/new
  def new
    @report_card_generator = ReportCardGenerator.new
  end

  # GET /report_card_generators/1/edit
  def edit
  end

  # POST /report_card_generators or /report_card_generators.json
  def create
    @report_card_generator = ReportCardGenerator.new(report_card_generator_params)

    respond_to do |format|
      if @report_card_generator.save
        GenerateReportCardJob.perform_later(@report_card_generator.id)

        format.html { redirect_to report_card_generator_url(@report_card_generator), notice: "Report card generator was successfully created." }
        format.json { render :show, status: :created, location: @report_card_generator }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @report_card_generator.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /report_card_generators/1 or /report_card_generators/1.json
  def update
    # ReportCardGenerator.generate_school_class_report_cards(@report_card_generator)
    GenerateReportCardJob.perform_later(@report_card_generator.id)

    respond_to do |format|
      format.html { redirect_to report_card_generator_url(@report_card_generator), notice: "Report card generator was successfully Regenerated." }
    end
  end

  # DELETE /report_card_generators/1 or /report_card_generators/1.json
  def destroy
    @report_card_generator.destroy!

    respond_to do |format|
      format.html { redirect_to report_card_generators_url, notice: "Report card generator was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def loading
  end

  def progress_state_api
    render json: {
      progress_state: @report_card_generator.progress_state,
      is_processing: @report_card_generator.is_processing,
      redirect_url: report_card_generator_path(@report_card_generator),
    }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_report_card_generator
    @report_card_generator = ReportCardGenerator.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def report_card_generator_params
    params.require(:report_card_generator).permit(:academic_year_id, :school_class_id, :term_id, :student_passed_num, :class_average, :school_id, :status, :failed_errors, :most_performed_students)
  end
end
