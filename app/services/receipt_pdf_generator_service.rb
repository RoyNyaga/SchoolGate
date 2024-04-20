class ReceiptPdfGeneratorService
  attr_accessor :pdf

  def initialize
    @pdf = Prawn::Document.new
  end

  def generate_pdf(qrcode_svg)
    @pdf.svg qrcode_svg, size: 13, style: :bold, align: :center
    @pdf
  end
end
