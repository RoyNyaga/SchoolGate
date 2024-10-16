class SchoolClassesController < ApplicationController
  layout "school_layout"
  before_action :check_for_current_school
  before_action :set_school_class, only: %i[ show edit update destroy ]
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

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_school_class
    @school_class = SchoolClass.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def school_class_params
    params.require(:school_class).permit(:school_id, :name, :level, :required_fee, :should_evaluate_multiple_competences_per_subject)
  end
end
