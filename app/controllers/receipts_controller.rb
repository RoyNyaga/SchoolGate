class ReceiptsController < ApplicationController
  layout "school_layout"
  skip_before_action :authenticate_teacher!, only: [:parents]
  before_action :set_receipt, only: %i[ show edit update destroy parents pdf_view pdf_download ]

  # GET /receipts or /receipts.json
  def index
    @receipts = Receipt.all
  end

  # GET /receipts/1 or /receipts/1.json
  def show
    @fee = @receipt.fee
    @school = @receipt.school
    qrcode = RQRCode::QRCode.new("https://www.schoolgate.org/receipts/verification?transaction_reference=#{@receipt.transaction_reference}")
    @svg = qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 4,
      standalone: true,
      use_path: true,

    )
  end

  # GET /receipts/new
  def new
    @receipt = Receipt.new
  end

  # GET /receipts/1/edit
  def edit
  end

  # POST /receipts or /receipts.json
  def create
    @receipt = Receipt.new(receipt_params)

    respond_to do |format|
      if @receipt.save
        format.html { redirect_to receipt_url(@receipt), notice: "Receipt was successfully created." }
        format.json { render :show, status: :created, location: @receipt }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @receipt.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /receipts/1 or /receipts/1.json
  def update
    respond_to do |format|
      if @receipt.update(receipt_params)
        format.html { redirect_to receipt_url(@receipt), notice: "Receipt was successfully updated." }
        format.json { render :show, status: :ok, location: @receipt }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @receipt.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /receipts/1 or /receipts/1.json
  def destroy
    @receipt.destroy!

    respond_to do |format|
      format.html { redirect_to receipts_url, notice: "Receipt was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def verification
    @receipt = Receipt.find_by(transaction_reference: params[:transaction_reference])
  end

  def parents
    qrcode = RQRCode::QRCode.new("https://www.schoolgate.org/receipts/verification?transaction_reference=#{@receipt.transaction_reference}")
    @school = @receipt.school
    @svg = qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 4,
      standalone: true,
      use_path: true,

    )
    render layout: "application"
  end

  def pdf_view
    pdf = @receipt.generate_receipt
    respond_to do |format|
      format.html # regular HTML response
      format.pdf do
        send_data pdf.render, filename: "receipt.pdf",
                              type: "application/pdf",
                              disposition: "inline" # or 'attachment' to force download
      end
    end
  end

  def pdf_download
    pdf = @receipt.generate_receipt
    student = @receipt.student

    respond_to do |format|
      format.pdf do
        send_data pdf.render, filename: "#{student.full_name.gsub(" ", "-")}-receipt-#{@receipt.academic_year.year}.pdf",
                              type: "application/pdf",
                              disposition: "attachment" # Forces the file to download
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_receipt
    @receipt = Receipt.includes(:school, :fee).find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def receipt_params
    params.require(:receipt).permit(:school_id, :teacher_id, :academic_year_id, :student_id, :fee_id, :transaction_reference, :has_error)
  end
end
