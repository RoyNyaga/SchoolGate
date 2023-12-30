class ReportCardsController < ApplicationController
  layout "school_layout"
  before_action :set_report_card, only: %i[ show edit update destroy ]

  # GET /report_cards or /report_cards.json
  def index
    @term = Term.new
    @report_cards = ReportCard.all
    @terms = current_school.terms
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
