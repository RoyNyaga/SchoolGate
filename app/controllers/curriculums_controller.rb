class CurriculumsController < ApplicationController
  before_action :check_for_current_school
  before_action :set_curriculum, only: %i[ show edit update destroy ]

  # GET /curriculums or /curriculums.json
  def index
    @curriculums = Curriculum.all
  end

  # GET /curriculums/1 or /curriculums/1.json
  def show
  end

  # GET /curriculums/new
  def new
    @subject = Subject.find(params[:subject_id])
    @curriculum = Curriculum.new
  end

  # GET /curriculums/1/edit
  def edit
  end

  # POST /curriculums or /curriculums.json
  def create
    @curriculum = Curriculum.new(curriculum_params)
    @subject = @curriculum.subject
    # respond_to do |format|
    if @curriculum.save
      flash[:success] = "Curriculum was successfully Created"
      redirect_to for_teacher_subject_path(@subject)
    else
      render "subjects#for_teacher", status: :unprocessable_entity
    end
    # end
  end

  # PATCH/PUT /curriculums/1 or /curriculums/1.json
  def update
    respond_to do |format|
      if @curriculum.update(curriculum_params)
        format.html { redirect_to for_teacher_subject_path(@curriculum.subject), notice: "Curriculum was successfully updated." }
        # format.turbo_stream { flash[:success] = "Succfully Updated Curriculum" }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @curriculum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /curriculums/1 or /curriculums/1.json
  def destroy
    @curriculum.destroy!

    respond_to do |format|
      format.turbo_stream { flash.now[:success] = "Successfully deleted Curriculum" }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_curriculum
    @curriculum = Curriculum.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def curriculum_params
    params.require(:curriculum).permit(:school_id, :school_class_id, :teacher_id, :subject_id, :title,
                                       :academic_year)
  end
end
