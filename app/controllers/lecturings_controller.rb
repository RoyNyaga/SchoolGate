class LecturingsController < ApplicationController
  before_action :set_lecturing, only: %i[ show edit update destroy ]

  # GET /lecturings or /lecturings.json
  def index
    @lecturings = Lecturing.all
  end

  # GET /lecturings/1 or /lecturings/1.json
  def show
  end

  # GET /lecturings/new
  def new
    @lecturing = Lecturing.new
  end

  # GET /lecturings/1/edit
  def edit
  end

  # POST /lecturings or /lecturings.json
  def create
    @lecturing = Lecturing.new(lecturing_params)
    @course = @lecturing.course
    respond_to do |format|
      if @lecturing.save
        format.html { redirect_to department_url(@lecturing.course.department), notice: "Course was successfully assigned." }
        format.json { render :show, status: :created, location: @lecturing }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @lecturing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lecturings/1 or /lecturings/1.json
  def update
    respond_to do |format|
      if @lecturing.update(lecturing_params)
        format.html { redirect_to lecturing_url(@lecturing), notice: "Lecturing was successfully updated." }
        format.json { render :show, status: :ok, location: @lecturing }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @lecturing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lecturings/1 or /lecturings/1.json
  def destroy
    @lecturing.destroy!

    respond_to do |format|
      format.html { redirect_to lecturings_url, notice: "Lecturing was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_lecturing
    @lecturing = Lecturing.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def lecturing_params
    params.require(:lecturing).permit(:course_id, :teacher_id)
  end
end
