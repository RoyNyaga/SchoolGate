class FeesController < ApplicationController
  layout "school_layout"
  before_action :check_for_current_school
  before_action :set_fee, only: %i[ show edit update destroy ]

  # GET /fees or /fees.json
  def index
    if params[:is_search].present?
      sql = "fees.school_id = #{current_school.id}"
      sql += " AND academic_year_id = #{params[:academic_year_id].to_i}" if params[:academic_year_id].present?
      sql += " AND lower(students.full_name) like '%#{params[:student_name].downcase}%'" if params[:student_name].present?
      sql += " AND percentage_complete > #{params[:percent_complete_greater_than]}" if params[:percent_complete_greater_than].present?
      sql += " AND percentage_complete < #{params[:percent_complete_lesser_than]}" if params[:percent_complete_lesser_than].present?
      sql += " AND fees.school_class_id = #{params[:school_class_id]}" if params[:school_class_id].present?
      @fees = Fee.joins(:student).includes(:school, :school_class, :student).where(sql)
    else
      @fees = current_school.fees.includes(:school, :school_class, :student)
    end
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
      @fee.update_records << { updator: current_teacher.full_name, updator_id: current_teacher.id, changes: params[:fee][:installments], date: Date.today.to_s }.to_s
      @fee.save
      respond_to do |format|
        # format.html { redirect_to fee_url(@fee), success: "Fee was successfully updated." }
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
    @academic_year_id = if params[:academic_year_id].present?
        params[:academic_year_id].to_i
      else
        current_school.active_academic_year.id
      end
    @academic_year = AcademicYear.find_by(id: @academic_year_id)
    @fees = @academic_year.fees
    @academic_year_text = @academic_year.year
    @overall_fee_paid = @fees.map(&:total_fee_paid).sum
  end

  def search
    sql = "fees.school_id = #{current_school.id}"
    sql += " AND academic_year = '#{params[:academic_year_id]}'" if params[:academic_year_id].present?
    sql += " AND lower(students.full_name) like '%#{params[:student_name].downcase}%'" if params[:student_name].present?
    sql += " AND percentage_complete > #{params[:percent_complete_greater_than]}" if params[:percent_complete_greater_than].present?
    sql += " AND percentage_complete < #{params[:percent_complete_lesser_than]}" if params[:percent_complete_lesser_than].present?
    sql += " AND fees.school_class_id = #{params[:school_class_id]}" if params[:school_class_id].present?
    @fees = Fee.joins(:student).includes(:school, :school_class, :student).where(sql)
    # respond_to do |format|
    #   # format.html { render "fees#index", success: "Fee was successfully updated." }
    #   format.turbo_stream { flash.now[:success] = "#{@fees.count} Results Found" }
    # end
    redirect_to request.referer
  end

  def pdf_download
    pdf_file = ReceiptPdfGeneratorService.new
    qrcode = RQRCode::QRCode.new("https://schoolgate.org/students/")
    @qrcode_svg = qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 4,
      standalone: true,
      use_path: true,

    )

    # binding.break
    send_data(pdf_file.generate_pdf(@qrcode_svg).render, filename: "test-file", type: "application/pdf", disposition: "inline")
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_fee
    @fee = Fee.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def fee_params
    params[:fee][:installments] = params[:fee][:installments].select { |v| v.present? } # remove empty installment values
    params.require(:fee).permit(:school_id, :school_class_id, :teacher_id, :student_id, :academic_year_id, :academic_year_text, :installment_num,
                                :total_fee_paid, :is_completed, installments: [])
  end
end
