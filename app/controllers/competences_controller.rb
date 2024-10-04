class CompetencesController < ApplicationController
  before_action :set_competence, only: [:edit, :update, :destroy]

  def edit
    @subject = @competence.subject
  end

  def new
    @subject = Subject.find_by(id: params[:subject_id])
    @competence = Competence.new
  end

  def create
    @competence = Competence.new(competence_params)
    respond_to do |format|
      if @competence.save
        # format.html { redirect_to main_topic_url(@main_topic), notice: "Main topic was successfully created." }
        format.turbo_stream { flash.now[:success] = "Competence Successfully added." }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @competence.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @competence.update(competence_params)
      redirect_to edit_subject_path(@competence.subject)
    end
  end

  def destroy
    @competence.destroy!

    respond_to do |format|
      format.turbo_stream { flash.now[:success] = "Successfully deleted Competence" }
    end
  end

  private

  def competence_params
    params.require(:competence).permit(:school_id, :school_class_id, :subject_id, :title)
  end

  def set_competence
    @competence = Competence.find_by(id: params[:id])
  end
end
