class PdfGeneratorService
  attr_accessor :report_cards

  def initialize(report_cards)
    @pdf = Prawn::Document.new
    # @document_width = @pdf.bounds.width
    @report_cards = report_cards
  end

  def add_report_card(report_card)
    header = ["", "subject", "Seq1", "Seq2", "Avg/20", "Coef", "Score", "Grads", "Rank", "Teacher", "Remark"]
  end

  def add_subject_info
  end

  def generate_pdf
    @report_cards.each do |report_card|
    end
  end
end
