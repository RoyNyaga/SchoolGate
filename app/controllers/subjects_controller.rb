class SubjectsController < ApplicationController
  layout "school_layout"
  before_action :check_for_current_school
  before_action :set_subject, only: %i[ show edit update destroy for_teacher ]

  # GET /subjects or /subjects.json
  def index
    @subjects = current_teacher.class_subjects
  end

  # GET /subjects/1 or /subjects/1.json
  def show
    @school_class = @subject.school_class
    @active_teachings = @subject.teachings.where(status: true)
    @inactive_teachings = @subject.teachings.where(status: false)
  end

  # GET /subjects/new
  def new
    @subject = Subject.new
  end

  # GET /subjects/1/edit
  def edit
    @school_class = @subject.school_class
  end

  # POST /subjects or /subjects.json
  def create
    @subject = Subject.new(subject_params)

    respond_to do |format|
      if @subject.save
        format.html { redirect_to subject_url(@subject), notice: "Subject was successfully created." }
        format.json { render :show, status: :created, location: @subject }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subjects/1 or /subjects/1.json
  def update
    respond_to do |format|
      if @subject.update(subject_params)
        format.html { redirect_to subject_url(@subject), notice: "Subject was successfully updated." }
        format.json { render :show, status: :ok, location: @subject }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subjects/1 or /subjects/1.json
  def destroy
    @subject.destroy!

    respond_to do |format|
      format.html { redirect_to subjects_url, notice: "Subject was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def for_teacher
    @sequences = current_teacher.sequences.where(subject_id: @subject.id)
    @curriculums = @current_teacher.curriculums.where(subject_id: @subject.id)
    week_start_and_end_dates = Progress.generate_start_and_end_week_dates(Time.now)
    @current_week_progresses = current_teacher.progresses.where("created_at >= '#{week_start_and_end_dates[:start]}' AND created_at <= '#{week_start_and_end_dates[:end]}' AND school_id = #{current_school.id}")
    @current_week_hours_covered = Progress.calc_total_time(@current_week_progresses)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_subject
    @subject = Subject.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def subject_params
    params.require(:subject).permit(:school_id, :school_class_id, :name, :coefficient, :less_than_equal_to_5, :less_than_equal_to_9, :less_than_equal_to_12,
                                    :less_than_equal_to_15, :less_than_equal_to_18, :less_than_equal_to_20)
  end
end
