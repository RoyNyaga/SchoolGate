class SequencesController < ApplicationController
  layout "school_layout"
  before_action :check_for_current_school
  before_action :set_sequence, only: %i[ show edit update destroy toggle_approval ]

  # GET /sequences or /sequences.json
  def index
    @sequences = current_school.sequences.includes(:school_class, :teacher, :subject).paginate(page: params[:page], per_page: 10).order(created_at: :desc)
  end

  # GET /sequences/1 or /sequences/1.json
  def show
  end

  # GET /sequences/new
  def new
    @school_class = SchoolClass.find(params[:school_class_id])
    @subject = Subject.find(params[:subject_id])
    @sequence = Sequence.new
    @competences = @subject.competences
  end

  # GET /sequences/1/edit
  def edit
    @school_class = @sequence.school_class
    @subject = @sequence.subject
  end

  # POST /sequences or /sequences.json
  def create
    @sequence = Sequence.new(sequence_params)
    @school_class = @sequence.school_class
    @subject = @sequence.subject
    respond_to do |format|
      if @sequence.save
        format.html { redirect_to sequence_url(@sequence), notice: "Sequence was successfully created." }
        format.json { render :show, status: :created, location: @sequence }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sequence.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sequences/1 or /sequences/1.json
  def update
    @school_class = @sequence.school_class
    @subject = @sequence.subject
    respond_to do |format|
      if @sequence.update(sequence_params)
        format.html { redirect_to sequence_url(@sequence), notice: "Sequence was successfully updated." }
        format.json { render :show, status: :ok, location: @sequence }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sequence.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sequences/1 or /sequences/1.json
  def destroy
    @sequence.destroy!

    respond_to do |format|
      format.html { redirect_to sequences_url, notice: "Sequence was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def toggle_approval
    if @sequence.update(status: params[:status].to_i)
      flash[:success] = "Successfully approved Sequence"
    else
      flash[:error] = "Error: #{@sequence.errors.full_messages.join(", ")}"
    end
    redirect_to request.referer
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_sequence
    @sequence = Sequence.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def sequence_params
    school_class = SchoolClass.find_by(id: params[:sequence][:school_class_id])
    if school_class.should_evaluate_multiple_competences_per_subject
      params.require(:sequence).permit(
        :school_id, :academic_year_id, :school_class_id, :teacher_id, :subject_id, :evaluation_method, :term_id, :seq_num,
        marks: [
          :id, :name, :is_enrolled,
          mark: [
            :competence_id, :competence_title, :competence_mark,
          ],
        ],
      )
    else
      params.require(:sequence).permit(:school_id, :school_class_id, :academic_year_id, :term_id, :evaluation_method, :teacher_id, :seq_num, :subject_id,
                                       :academic_year_start, :academic_year_end, marks: [:id, :name, :mark, :is_enrolled])
    end
  end
end
