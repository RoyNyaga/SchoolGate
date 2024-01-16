class FeesController < ApplicationController
  before_action :set_fee, only: %i[ show edit update destroy ]

  # GET /fees or /fees.json
  def index
    @fees = Fee.all.includes(:school, :school_class, :student)
  end

  # GET /fees/1 or /fees/1.json
  def show
  end

  # GET /fees/new
  def new
    @fee = Fee.new
  end

  # GET /fees/1/edit
  def edit
  end

  # POST /fees or /fees.json
  def create
    @fee = Fee.new(fee_params)

    respond_to do |format|
      if @fee.save
        format.html { redirect_to fee_url(@fee), notice: "Fee was successfully created." }
        format.json { render :show, status: :created, location: @fee }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @fee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fees/1 or /fees/1.json
  def update
    @fee.attributes = fee_params
    if @fee.valid?
      # @fee.update_records << { updator: current_teacher.name, changes: params[:fee][:installments] date: Date.today }
      # @fee.save
      respond_to do |format|
        format.html { redirect_to fee_url(@fee), success: "Fee was successfully updated." }
        format.turbo_stream { flash.now[:success] = "Fee was successfully updated." }
      end
    end
    # respond_to do |format|
    #     @fee.
    #     format.html { redirect_to fee_url(@fee), notice: "Fee was successfully updated." }
    #     format.json { render :show, status: :ok, location: @fee }
    #   else
    #     format.html { render :edit, status: :unprocessable_entity }
    #     format.json { render json: @fee.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # DELETE /fees/1 or /fees/1.json
  def destroy
    @fee.destroy!

    respond_to do |format|
      format.html { redirect_to fees_url, notice: "Fee was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_fee
    @fee = Fee.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def fee_params
    params.require(:fee).permit(:school_id, :school_class_id, :teacher_id, :student_id, :academic_year, :installment_num,
                                :total_fee_paid, :is_completed, installments: [])
  end
end
