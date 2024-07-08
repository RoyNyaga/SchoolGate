class TeachingsController < ApplicationController
  layout "school_layout"
  before_action :check_for_current_school
  before_action :set_teaching, only: %i[ show edit update destroy toggle_status ]

  # GET /teachings or /teachings.json
  def index
    @teachings = Teaching.all
  end

  # GET /teachings/1 or /teachings/1.json
  def show
  end

  # GET /teachings/new
  def new
    @teaching = Teaching.new
  end

  # GET /teachings/1/edit
  def edit
  end

  # POST /teachings or /teachings.json
  def create
    @teaching = Teaching.new(teaching_params)
    @subject = Subject.find_by(id: params[:teaching][:subject_id])

    respond_to do |format|
      if @teaching.save
        format.html { redirect_to request.referer, notice: "Teacher was successfully assigned!!" }
        format.json { render :show, status: :created, location: @teaching }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @teaching.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teachings/1 or /teachings/1.json
  def update
    respond_to do |format|
      if @teaching.update(teaching_params)
        format.html { redirect_to teaching_url(@teaching), notice: "Teaching was successfully updated." }
        format.json { render :show, status: :ok, location: @teaching }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @teaching.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teachings/1 or /teachings/1.json
  def destroy
    @teaching.destroy!

    respond_to do |format|
      format.html { redirect_to teachings_url, notice: "Teaching was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def toggle_status
    if @teaching.update(status: ActiveRecord::Type::Boolean.new.cast(params[:status]))
      flash[:success] = "Successfully Updated Assignment"
      redirect_to subject_path(@teaching.subject_id)
    else
      flash[:error] = "Sorry, Action could not be performed!!!"
      redirect_to subject_path(@teaching.subject_id)
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_teaching
    @teaching = Teaching.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def teaching_params
    params.require(:teaching).permit(:teacher_id, :subject_id, :school_class_id, :is_class_master)
  end
end
