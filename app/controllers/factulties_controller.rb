class FacultiesController < ApplicationController
  before_action :set_factulty, only: %i[ show edit update destroy ]

  # GET /factulties or /factulties.json
  def index
    @faculties = Factulty.all
  end

  # GET /factulties/1 or /factulties/1.json
  def show
  end

  # GET /factulties/new
  def new
    @faculty = Factulty.new
  end

  # GET /factulties/1/edit
  def edit
  end

  # POST /factulties or /factulties.json
  def create
    @faculty = Factulty.new(factulty_params)

    respond_to do |format|
      if @faculty.save
        format.html { redirect_to factulty_url(@faculty), notice: "Factulty was successfully created." }
        format.json { render :show, status: :created, location: @faculty }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @faculty.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /factulties/1 or /factulties/1.json
  def update
    respond_to do |format|
      if @faculty.update(factulty_params)
        format.html { redirect_to factulty_url(@faculty), notice: "Factulty was successfully updated." }
        format.json { render :show, status: :ok, location: @faculty }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @faculty.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /factulties/1 or /factulties/1.json
  def destroy
    @faculty.destroy!

    respond_to do |format|
      format.html { redirect_to factulties_url, notice: "Factulty was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_factulty
    @faculty = Factulty.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def factulty_params
    params.require(:faculty).permit(:school_id, :name)
  end
end
