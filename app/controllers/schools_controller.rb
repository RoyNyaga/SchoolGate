class SchoolsController < ApplicationController
  include ApplicationHelper # this is to enable us access the generate_modal_id helper method from this controller
  layout "school_layout"
  before_action :set_school, only: %i[ show edit update destroy update_logo ]
  before_action :check_for_current_school, except: %i[show index new create]
  before_action :check_administrator, except: %i[show index new create]

  # GET /schools or /schools.json
  def index
    @schools = School.without_settings_attr.joins(:workings).where(workings: { teacher_id: current_teacher.id, status: 0 }).distinct
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
    set_current_school(@school)
  end

  # POST /schools or /schools.json
  def create
    @school = current_teacher.schools.build(school_params)

    respond_to do |format|
      if @school.save
        SuperAdminWhatsappJob.perform_later("Super Admin Notification",
                                            admin_school_path(@school), "New School Notification: #{@school.full_name}", "super_admin_notification_template")

        school_admin_content = "Congratulations!!!!, You Succeeded in creating a school on SchoolGate. Please visit the tutorial page to see how to progress from here. For more help, please contact: (+237) 671-172-775"
        SchoolAdminWhatsappJob.perform_later(@school.id, ["principal"],
                                             school_path(id: @school.id, current_school_id: @school.id),
                                             school_admin_content, "administrator_notification_template")

        format.html { redirect_to edit_school_path(@school), notice: "School was successfully created." }
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
    @students = current_school.students.includes(:school_class, photo_attachment: :blob).paginate(page: params[:page], per_page: 20)
    @school_classes = current_school.school_classes.includes(:students)
  end

  def teachers
    @workings = current_school.workings.includes(teacher: :photo_attachment)
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

  def update_logo
    if @school.update(logo_params)
      render json: { image_url: url_for(@school.photo),
                     modal_id: generate_modal_id("photo_form", record: @school),
                     message: "Successfully Updated Logo", success: true }, status: :ok
    else
      render json: { message: @teacher.errors.full_messages, success: false }, status: :unprocessable_entity
    end
  end

  private

  def logo_params
    params.require(:school).permit(:photo)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_school
    @school = School.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def school_params
    params.require(:school).permit(:full_name, :abbreviation, :town, :address, :moto, :notification_contact, :activate_notification, :level_1_fees, :level_2_fees,
                                   :level_3_fees, :level_4_fees, :level_5_fees, :level_6_fees, :level_7_fees, :school_identifier, :education_level)
  end
end
