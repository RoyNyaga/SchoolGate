class AssessmentsController < ApplicationController
  layout "school_layout"
  before_action :set_assessment, only: %i[ show edit update destroy ]

  # GET /assessments or /assessments.json
  def index
    @assessments = Assessment.all
  end

  # GET /assessments/1 or /assessments/1.json
  def show
  end

  # GET /assessments/new
  def new
    @course = Course.find_by(id: params[:course_id])
    @academic_year = current_school.active_academic_year
    @semester = current_school.active_semester
    @enrollments = @course.enrollments.includes(:student).where(semester_id: @semester.id, academic_year_id: @academic_year.id)
    @assessment = Assessment.new
  end

  # GET /assessments/1/edit
  def edit
    @course = @assessment.course
    @academic_year = current_school.active_academic_year
    @semester = current_school.active_semester
    @enrollments = @course.enrollments.includes(:student).where(semester_id: @semester.id, academic_year_id: @academic_year.id)
  end

  def redirect_to_new
  end

  # POST /assessments or /assessments.json
  def create
    @assessment = Assessment.new(assessment_params)
    @course = @assessment.course

    respond_to do |format|
      if @assessment.save
        format.html { redirect_to for_lecturer_course_path(@course), notice: "Assessment was successfully created." }
        format.json { render :show, status: :created, location: @assessment }
      else
        @academic_year = current_school.active_academic_year
        @semester = current_school.active_semester
        @enrollments = @course.enrollments.includes(:student).where(semester_id: @semester.id, academic_year_id: @academic_year.id)
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @assessment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /assessments/1 or /assessments/1.json
  def update
    respond_to do |format|
      if @assessment.update(assessment_params)
        format.html { redirect_to assessment_url(@assessment), notice: "Assessment was successfully updated." }
        format.json { render :show, status: :ok, location: @assessment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @assessment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assessments/1 or /assessments/1.json
  def destroy
    @assessment.destroy!

    respond_to do |format|
      format.html { redirect_to assessments_url, notice: "Assessment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_assessment
    @assessment = Assessment.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def assessment_params
    params.require(:assessment).permit(:school_id, :academic_year_id, :course_id, :assessment_type,
                                       :semester_id, :course_name, :teacher_id,
                                       marks: [:id, :full_name, :mark, :is_present, :enrollment_id, :course_registration_id])
  end
end
