include ActionView::Helpers::NumberHelper

module ReceiptPdfConcern
  extend ActiveSupport::Concern

  included do
    def generate_receipt
      width = 650 * 0.75 # conversion from pixel to points
      height = 700 * 0.75 # conversion from pixel to points
      @school = school
      @student = student
      @pdf = Prawn::Document.new(page_size: [width, height], margin: [15, 10, 10, 15])
      add_school_logo_to_pdf
      letter_head
      reference_number_section
      history_section
      add_qr_code_to_pdf
      @pdf
    end

    def add_school_logo_to_pdf
      # Get the logo URL from ActiveStorage
      if @school.photo.attached?
        logo = StringIO.open(@school.photo.download)
        @pdf.image logo, fit: [60, 60], position: :center, at: [30, @pdf.bounds.top]
      end
    end

    def letter_head
      @pdf.indent(@pdf.bounds.width * 0.2) do
        @pdf.font "Times-Roman" do
          @pdf.text @school.full_name, size: 13, style: :bold, align: :center
        end
        @pdf.move_down 3
        @pdf.font("Courier") do
          @pdf.text "#{@school.address}", align: :center, size: 10
          @pdf.move_down 3

          @pdf.text "contact: #{@school.phone_number}", align: :center, size: 10
        end
        @pdf.move_down 15
        @pdf.font "Times-Roman" do
          @pdf.text "School Fee Payment Receipt", size: 12, style: :bold, align: :center
        end
      end
    end

    def reference_number_section
      @pdf.move_down 10
      # Define the width to occupy 60% of the PDF
      total_width = @pdf.bounds.width * 0.7
      column_widths = [total_width / 2.7, total_width / 1.4] # the total width should sum to the value of total_with

      # Define the personal information content (two columns, six rows)
      table_data = [
        ["Student name", "#{@student.full_name}"],
        ["Student matricule", "#{@student.matricule}"],
        ["Amount payed", "#{number_to_currency(amount, unit: "", precision: 0)} frs"],
        ["Reference No", "#{transaction_reference}"],
        ["Date", "#{readable_date(with_year: true)}"],
      ]

      # Indent to shift the table to the right (20% of the PDF width)
      @pdf.indent(@pdf.bounds.width * 0.2) do
        @pdf.table(table_data, column_widths: column_widths,
                               cell_style: { borders: [], :font => "Courier", size: 10, valign: :center, align: :left })
      end
    end

    def history_section
      @pdf.move_down 20
      @pdf.font "Courier" do
        @pdf.text "History", size: 12, style: :bold
      end
      @pdf.move_down 10
      # Define the width to occupy 60% of the PDF
      total_width = @pdf.bounds.width
      column_widths = [total_width / 2, total_width / 2] # the total width should sum to the value of total_with

      # Define the personal information content (two columns, six rows)
      table_data = [
        ["Installment No", "#{installment_num.humanize}"],
        ["Total Fee Payed", "#{number_to_currency(total_fees_paid_at_this_point, unit: "", precision: 0)} frs"],
        ["Required Fee", "#{number_to_currency(fee.required_fee, unit: "", precision: 0)} frs"],
        ["Balance", "#{number_to_currency(balance, unit: "", precision: 0)} frs"],
      ]

      @pdf.table(table_data, column_widths: column_widths,
                             cell_style: { :font => "Times-Roman", size: 10, valign: :center, align: :left })
    end

    def add_qr_code_to_pdf
      # Generate the QR code
      qrcode = RQRCode::QRCode.new("#{ENV["PRODUCTION_DOMAIN"]}/receipts/verification?transaction_reference=#{transaction_reference}")

      # Convert QR code to PNG image data in memory
      png = qrcode.as_png(
        bit_depth: 1,
        border_modules: 4,
        color_mode: ChunkyPNG::COLOR_GRAYSCALE,
        color: "black",
        file: nil,
        fill: "white",
        module_px_size: 6,
        resize_exactly_to: nil,
        resize_gte_to: nil,
        size: 120, # Set the desired size for the QR code
      )

      # Add the QR code image to the PDF from the in-memory PNG data
      @pdf.image StringIO.new(png.to_s), fit: [150, 150], at: [-40, 120] # Adjust size and position as needed
    end
  end
end
