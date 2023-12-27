class SchoolsController < ApplicationController
  layout "school_layout"
  before_action :check_for_current_school
  before_action :set_school, only: %i[ show edit update destroy ]
  before_action :check_for_current_school, except: %i[show index]

  # GET /schools or /schools.json
  def index
    @schools = current_teacher.schools
    render layout: "application"
  end

  # GET /schools/1 or /schools/1.json
  def show
    session[:current_school_id] = @school.id
  end

  # GET /schools/new
  def new
    @school = School.new
  end

  # GET /schools/1/edit
  def edit
  end

  # POST /schools or /schools.json
  def create
    @school = current_teacher.schools.build(school_params)

    respond_to do |format|
      if @school.save
        format.html { redirect_to school_url(@school), notice: "School was successfully created." }
        format.json { render :show, status: :created, location: @school }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @school.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /schools/1 or /schools/1.json
  def update
    respond_to do |format|
      if @school.update(school_params)
        format.html { redirect_to school_url(@school), notice: "School was successfully updated." }
        format.json { render :show, status: :ok, location: @school }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @school.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /schools/1 or /schools/1.json
  def destroy
    @school.destroy!

    respond_to do |format|
      format.html { redirect_to schools_url, notice: "School was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def classes
    @school_class = SchoolClass.new
    @school_classes = current_school.school_classes
  end

  def students
    @student = Student.new
    @students = current_school.students
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_school
    @school = School.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def school_params
    params.require(:school).permit(:full_name, :abbreviation, :town, :address, :moto)
  end
end
