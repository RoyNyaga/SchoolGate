class ReportCardsController < ApplicationController
  layout "school_layout"
  before_action :set_report_card, only: %i[ show edit update destroy ]

  # GET /report_cards or /report_cards.json
  def index
    @term = Term.new
    @report_cards = ReportCard.all
    @terms = current_school.terms
    @report_card = ReportCard.new
  end

  # GET /report_cards/1 or /report_cards/1.json
  def show
  end

  # GET /report_cards/new
  def new
    @report_card = ReportCard.new
  end

  # GET /report_cards/1/edit
  def edit
  end

  # POST /report_cards or /report_cards.json
  def create
    @report_card = ReportCard.new(report_card_params)

    respond_to do |format|
      if @report_card.save
        format.html { redirect_to report_card_url(@report_card), notice: "Report card was successfully created." }
        format.json { render :show, status: :created, location: @report_card }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @report_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /report_cards/1 or /report_cards/1.json
  def update
    respond_to do |format|
      if @report_card.update(report_card_params)
        format.html { redirect_to report_card_url(@report_card), notice: "Report card was successfully updated." }
        format.json { render :show, status: :ok, location: @report_card }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @report_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /report_cards/1 or /report_cards/1.json
  def destroy
    @report_card.destroy!

    respond_to do |format|
      format.html { redirect_to report_cards_url, notice: "Report card was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def bulk_create
    if params[:report_card][:school_class_id].blank?
      flash[:error] = "Please provide a valid class"
      redirect_to request.referer
    else
      @school_class = SchoolClass.find(params[:report_card][:school_class_id])
      flash[:success] = "Successfully generated Report Cards for #{@school_class.name}"
      redirect_to request.referer
      ReportCard.generate_school_class_report_cards(params[:report_card][:school_class_id], params[:report_card][:term_id])
    end
  end

  def pdf_test
    report_pdf = Prawn::Document.new
    # subject_table = Prawn::Table
    report_pdf.bounding_box([20, 730], width: 500, height: 650) do
      report_pdf.text "here is my text"
      report_pdf.table([["short", "short", "loooooooooooooooooooong"],
                        ["short", "loooooooooooooooooooong", "short"],
                        ["loooooooooooooooooooong", "short", "short"]])
      report_pdf.transparent(1) { report_pdf.stroke_bounds }
    end

    send_data(report_pdf.render, filename: "test-file", type: "application/pdf", disposition: "inline")
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_report_card
    @report_card = ReportCard.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def report_card_params
    params.require(:report_card).permit(:school_id, :school_class_id, :term_id, :average, :rank, :class_average, :passed_subjects)
  end
end
