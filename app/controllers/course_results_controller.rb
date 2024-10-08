class CourseResultsController < ApplicationController
  before_action :set_course_result, only: %i[ show edit update destroy ]

  # GET /course_results or /course_results.json
  def index
    @course_results = CourseResult.all
  end

  # GET /course_results/1 or /course_results/1.json
  def show
  end

  # GET /course_results/new
  def new
    @course_result = CourseResult.new
  end

  # GET /course_results/1/edit
  def edit
  end

  # POST /course_results or /course_results.json
  def create
    @course_result = CourseResult.new(course_result_params)

    respond_to do |format|
      if @course_result.save
        format.html { redirect_to course_result_url(@course_result), notice: "Course result was successfully created." }
        format.json { render :show, status: :created, location: @course_result }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /course_results/1 or /course_results/1.json
  def update
    respond_to do |format|
      if @course_result.update(course_result_params)
        format.html { redirect_to course_result_url(@course_result), notice: "Course result was successfully updated." }
        format.json { render :show, status: :ok, location: @course_result }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /course_results/1 or /course_results/1.json
  def destroy
    @course_result.destroy!

    respond_to do |format|
      format.html { redirect_to course_results_url, notice: "Course result was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course_result
      @course_result = CourseResult.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def course_result_params
      params.require(:course_result).permit(:school_id, :student_id, :course_id, :academic_year_id, :semester_id, :ca_mark, :exam_mark, :resit_mark, :total_mark, :has_resit, :is_validated, :credit_val)
    end
end
