class WorkingsController < ApplicationController
  layout "school_layout"
  before_action :check_for_current_school
  before_action :set_working, only: %i[ show edit update destroy ]

  # GET /workings or /workings.json
  def index
    @workings = Working.all
    @invitation = Invitation.new
  end

  # GET /workings/1 or /workings/1.json
  def show
  end

  # GET /workings/new
  def new
    @working = Working.new
  end

  # GET /workings/1/edit
  def edit
  end

  # POST /workings or /workings.json
  def create
    @working = Working.new(working_params)

    respond_to do |format|
      if @working.save
        format.html { redirect_to working_url(@working), notice: "Working was successfully created." }
        format.json { render :show, status: :created, location: @working }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @working.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /workings/1 or /workings/1.json
  def update
    respond_to do |format|
      if @working.update(working_params)
        format.html { redirect_to working_url(@working), notice: "Working was successfully updated." }
        format.json { render :show, status: :ok, location: @working }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @working.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /workings/1 or /workings/1.json
  def destroy
    @working.destroy!

    respond_to do |format|
      format.html { redirect_to workings_url, notice: "Working was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_working
    @working = Working.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def working_params
    params.require(:working).permit(:school_id, :teacher_id, :permission, :agreed_salary, :job_description)
  end
end
