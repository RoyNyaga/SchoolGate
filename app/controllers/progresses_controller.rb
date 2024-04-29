class ProgressesController < ApplicationController
  layout "school_layout"
  before_action :check_for_current_school
  before_action :set_progress, only: %i[ show edit update destroy more_details ]

  # GET /progresses or /progresses.json
  def index
    @progresses = Progress.all
  end

  # GET /progresses/1 or /progresses/1.json
  def show
  end

  # GET /progresses/new
  def new
    @progress = Progress.new
    @subject = Subject.find(params[:subject_id])
    @curriculums = Curriculum.where(subject_id: @subject.id, teacher_id: current_teacher.id,
                                    academic_year: current_school.active_academic_year.year)
  end

  # GET /progresses/1/edit
  def edit
    @subject = @progress.subject
    @curriculums = Curriculum.where(subject_id: @subject.id, teacher_id: current_teacher.id,
                                    academic_year: current_school.active_academic_year.year)

    topic_ids = Progress.string_to_hash_arr(@progress.topics).map { |t| t["id"] }
    @topics = Topic.where(id: topic_ids)
  end

  # POST /progresses or /progresses.json
  def create
    @progress = Progress.new(progress_params)

    respond_to do |format|
      if @progress.save
        topic_ids = Progress.string_to_hash_arr(@progress.topics).map { |t| t["id"].to_i }
        Progress.update_curriculum(topic_ids)
        format.html { redirect_to for_teacher_subject_path(@progress.subject_id), notice: "Progress was successfully created." }
        format.json { render :show, status: :created, location: @progress }
      else
        @subject = Subject.find(@progress.subject_id)
        @curriculums = Curriculum.where(subject_id: @subject.id, teacher_id: current_teacher.id,
                                        academic_year: current_school.active_academic_year.year)
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @progress.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /progresses/1 or /progresses/1.json
  def update
    respond_to do |format|
      if @progress.update(progress_params)
        topic_ids = Progress.string_to_hash_arr(@progress.topics).map { |t| t["id"].to_i }
        Progress.update_curriculum(topic_ids)
        format.html { redirect_to progresses_teacher_path(current_teacher), success: "Progress was successfully updated." }
        format.json { render :show, status: :ok, location: @progress }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @progress.errors, status: :unprocessable_entity }
      end
    end
  end

  def more_details
    topic_ids = Progress.string_to_hash_arr(@progress.topics).map { |t| t["id"] }
    @topics = Topic.where(id: topic_ids)
    absent_student_ids = Progress.string_to_hash_arr(@progress.absent_students).map { |t| t["id"] }
    @absent_students = Student.where(id: absent_student_ids)
  end

  # DELETE /progresses/1 or /progresses/1.json
  def destroy
    @progress.destroy!

    respond_to do |format|
      format.html { redirect_to progresses_url, notice: "Progress was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_progress
    @progress = Progress.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def progress_params
    params[:progress][:absent_students] = [] if params[:progress][:absent_students].nil?
    params.require(:progress).permit(:school_id, :subject_id, :teacher_id, :duration, :term_id, :academic_year,
                                     :seq_num, :hours, :mins, :school_class_id, topics: [:id, :progress], absent_students: [:id, :full_name])
  end
end
