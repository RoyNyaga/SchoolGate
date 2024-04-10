class CourseRegistrationsController < ApplicationController
  before_action :set_course_registration, only: %i[ show edit update destroy ]

  # GET /course_registrations or /course_registrations.json
  def index
    @course_registrations = CourseRegistration.all
  end

  # GET /course_registrations/1 or /course_registrations/1.json
  def show
  end

  # GET /course_registrations/new
  def new
    @course_registration = CourseRegistration.new
  end

  # GET /course_registrations/1/edit
  def edit
  end

  # POST /course_registrations or /course_registrations.json
  def create
    @course_registration = CourseRegistration.new(course_registration_params)

    respond_to do |format|
      if @course_registration.save
        format.html { redirect_to course_registration_url(@course_registration), notice: "Course registration was successfully created." }
        format.json { render :show, status: :created, location: @course_registration }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course_registration.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /course_registrations/1 or /course_registrations/1.json
  def update
    respond_to do |format|
      if @course_registration.update(course_registration_params)
        format.html { redirect_to course_registration_url(@course_registration), notice: "Course registration was successfully updated." }
        format.json { render :show, status: :ok, location: @course_registration }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course_registration.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /course_registrations/1 or /course_registrations/1.json
  def destroy
    @course_registration.destroy!

    respond_to do |format|
      format.html { redirect_to course_registrations_url, notice: "Course registration was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course_registration
      @course_registration = CourseRegistration.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def course_registration_params
      params.require(:course_registration).permit(:school_id, :student_id, :academic_year_id, :semester_id, :credit_val, :courses)
    end
end
