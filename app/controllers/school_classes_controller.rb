class SchoolClassesController < ApplicationController
  layout "school_layout"
  before_action :check_for_current_school
  before_action :set_school_class, only: %i[ show edit update destroy list fees view_class_list_pdf performance_sheets]
  before_action :check_for_current_school

  # GET /school_classes or /school_classes.json
  def index
    @school_classes = current_school.school_classes
  end

  # GET /school_classes/1 or /school_classes/1.json
  def show
    @subject = Subject.new
    @subjects = @school_class.subjects
  end

  # GET /school_classes/new
  def new
    @school_class = SchoolClass.new
  end

  # GET /school_classes/1/edit
  def edit
  end

  # POST /school_classes or /school_classes.json
  def create
    @school_class = SchoolClass.new(school_class_params)

    respond_to do |format|
      if @school_class.save
        SchoolAdminWhatsappJob.perform_later(@school_class.school_id, ["principal"], school_class_path(id: @school_class.id,
                                                                                                       current_school_id: current_school.id),
                                             "A new Class has been added to your school: #{@school_class.name}",
                                             "administrator_notification_template")
        format.html { redirect_to school_class_url(@school_class), notice: "School class was successfully created." }
        format.json { render :show, status: :created, location: @school_class }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @school_class.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /school_classes/1 or /school_classes/1.json
  def update
    respond_to do |format|
      if @school_class.update(school_class_params)
        format.html { redirect_to school_class_url(@school_class), notice: "School class was successfully updated." }
        format.json { render :show, status: :ok, location: @school_class }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @school_class.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /school_classes/1 or /school_classes/1.json
  def destroy
    @school_class.destroy!

    respond_to do |format|
      format.html { redirect_to school_classes_url, notice: "School class was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def list
    @students = @school_class.students.order(full_name: :asc)
    if params[:status] == "active"
      @students = @students.active
      download_response(params[:status]) if params[:download] == "true"
    elsif params[:status] == "dropout"
      @students = @students.dropout
      download_response(params[:status]) if params[:download] == "true"
    elsif params[:status] == "dismissed"
      @students = @students.dismissed
      download_response(params[:status]) if params[:download] == "true"
    else
      download_response(params[:status]) if params[:download] == "true"
    end
  end

  def fees
    @fees = @school_class.fees
      .where(academic_year_id: current_school.active_academic_year.id)
      .includes(:school, :school_class, :student)
      .joins(:student)
      .order("students.full_name ASC")
      .paginate(page: params[:page], per_page: 20)
    if params[:download] == "true"
      pdf = @school_class.generate_fees_based_class_list
      respond_to do |format|
        format.pdf do
          send_data pdf.render, filename: "#{@school_class.name.gsub(" ", "-")}--students-Fees-class-list-#{SchoolClass.generate_time_stamp}.pdf",
                                type: "application/pdf",
                                disposition: "attachement" # or inline, to view online
        end
      end
    end
  end

  def view_class_list_pdf # for testing purposes
    pdf = @school_class.generate_class_list
    respond_to do |format|
      format.pdf do
        send_data pdf.render, filename: "#{@school_class.name.gsub(" ", "-")}-#{SchoolClass.generate_time_stamp}.pdf",
                              type: "application/pdf",
                              disposition: "inline" # Forces the file to download
      end
    end
  end

  def performance_sheets
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_school_class
    @school_class = SchoolClass.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def school_class_params
    params.require(:school_class).permit(:school_id, :name, :level, :required_fee, :should_evaluate_multiple_competences_per_subject)
  end

  def download_response(status)
    pdf = @school_class.generate_class_list(status: status)
    respond_to do |format|
      format.pdf do
        send_data pdf.render, filename: "#{@school_class.name.gsub(" ", "-")}-#{status}-students-class-list-#{SchoolClass.generate_time_stamp}.pdf",
                              type: "application/pdf",
                              disposition: "attachement" # or inline, to view online
      end
    end
  end
end
