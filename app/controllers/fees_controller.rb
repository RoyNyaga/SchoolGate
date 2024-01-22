class FeesController < ApplicationController
  layout "school_layout"
  before_action :set_fee, only: %i[ show edit update destroy ]

  # GET /fees or /fees.json
  def index
    @academic_year_list = Fee.academic_year_list_per_school(current_school)
    @fees = current_school.fees.includes(:school, :school_class, :student)
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
      @fee.update_records << { updator: current_teacher.name, changes: params[:fee][:installments], date: Date.today.to_s }.to_s
      @fee.save
      respond_to do |format|
        format.html { redirect_to fee_url(@fee), success: "Fee was successfully updated." }
        format.turbo_stream { flash.now[:success] = "Fee was successfully updated." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /fees/1 or /fees/1.json
  def destroy
    @fee.destroy!

    respond_to do |format|
      format.html { redirect_to fees_url, notice: "Fee was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def statistics
    @fees = Fee.all
    @overall_fee_paid = @fees.map(&:total_fee_paid).sum
  end

  def search
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_fee
    @fee = Fee.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def fee_params
    params[:fee][:installments] = params[:fee][:installments].select { |v| v.present? } # remove empty installment values
    params.require(:fee).permit(:school_id, :school_class_id, :teacher_id, :student_id, :academic_year, :installment_num,
                                :total_fee_paid, :is_completed, installments: [])
  end
end
