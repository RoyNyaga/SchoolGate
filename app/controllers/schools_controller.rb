class SchoolsController < ApplicationController
  layout "school_layout"
  before_action :set_school, only: %i[ show edit update destroy ]
  before_action :check_for_current_school, except: %i[show index new]

  # GET /schools or /schools.json
  def index
    @schools = School.without_settings_attr.joins(:workings).where(workings: { teacher_id: current_teacher.id }).distinct
    render layout: "application"
  end

  # GET /schools/1 or /schools/1.json
  def show
    set_current_school(@school)
  end

  # GET /schools/new
  def new
    @school = School.new
    render layout: "application"
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
    @school_classes = current_school.school_classes.includes(:teachers, :students)
  end

  def students
    @student = Student.new
    @students = current_school.students
    @school_classes = current_school.school_classes.includes(:students)
  end

  def teachers
    @workings = current_school.workings
  end

  def invitations
    @status = params[:status] || "pending"
    @invitations = current_school.invitations.send(@status)
  end

  def contracts
    @workings = current_school.workings
  end

  def permissions
    @workings = current_school.workings
  end

  def progresses
    # week_start_and_end_dates = Progress.generate_start_and_end_week_dates(Time.now)
    # @progresses = current_school.progresses.where("created_at >= '#{week_start_and_end_dates[:start]}' AND created_at <= '#{week_start_and_end_dates[:end]}'")
    @progresses = current_school.progresses
    @total_hours_mins_time = Progress.calc_total_time(@progresses)
    @topics_covered = @progresses.map { |p| p.topics.count }.sum
    @absentist_num = @progresses.map { |p| p.absent_students.count }.sum
  end

  def faculties
    @faculties = current_school.faculties
  end

  def departments
    @departments = current_school.departments
  end

  def levels
    @school_classes = current_school.school_classes
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_school
    @school = School.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def school_params
    params.require(:school).permit(:full_name, :abbreviation, :town, :address, :moto, :level_1_fees, :level_2_fees,
                                   :level_3_fees, :level_4_fees, :level_5_fees, :level_6_fees, :level_7_fees, :school_identifier, :education_level)
  end
end
