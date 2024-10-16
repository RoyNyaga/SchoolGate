module StudentPdfConcern
  extend ActiveSupport::Concern

  included do
    def generate_id_card(is_front_section: false)
      width = 525 * 0.75 # conversion from pixel to points
      height = 300 * 0.75 # conversion from pixel to points
      @school = school
      @pdf = Prawn::Document.new(page_size: [width, height], margin: [15, 10, 10, 15])
      is_front_section ? generate_front_section : generate_back_section
      @pdf
    end

    def generate_front_section
      letter_head
      add_school_logo_to_pdf
      student_personal_info(is_front_section: true)
      add_student_avatar
    end

    def generate_back_section
      add_qr_code_to_pdf
      student_personal_info(is_front_section: false)
      @pdf
    end

    def add_qr_code_to_pdf
      # Generate the QR code
      qrcode = RQRCode::QRCode.new("#{ENV["PRODUCTION_DOMAIN"]}/students/#{id}")

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
      @pdf.image StringIO.new(png.to_s), fit: [150, 150], at: [-25, 214] # Adjust size and position as needed
    end

    def letter_head
      @pdf.indent(@pdf.bounds.width * 0.2) do
        @pdf.font "Times-Roman" do
          @pdf.text "Republic Of Cameroon", size: 12, style: :bold, align: :center
        end
        @pdf.move_down 3
        @pdf.font("Courier") do
          @pdf.text "Peace - Work - Fatherland", align: :center, size: 10
          @pdf.move_down 3

          @pdf.text @school.ministry_type_letter_head, align: :center, size: 10
        end
        @pdf.move_down 3
        @pdf.font "Times-Roman" do
          @pdf.text @school.full_name, size: 13, style: :bold, align: :center
        end
      end
    end

    def add_school_logo_to_pdf
      # Get the logo URL from ActiveStorage
      if @school.photo.attached?
        logo = StringIO.open(@school.photo.download)
        @pdf.image logo, fit: [60, 60], position: :center, at: [30, @pdf.bounds.top]
      end
    end

    def add_student_avatar
      # Get the logo URL from ActiveStorage
      if photo.attached?
        avatar = StringIO.open(photo.download)
        @pdf.image avatar, fit: [100, 100], position: :center, at: [2, 127]
      end
    end

    def student_personal_info(is_front_section: false)
      @pdf.move_down 15
      # Define the width to occupy 60% of the PDF
      total_width = @pdf.bounds.width * 0.6
      column_widths = [total_width / 2, total_width / 1.62] # the total width should sum to the value of total_with

      # Define the personal information content (two columns, six rows)
      personal_info = is_front_section ? [
        ["Surname", "#{first_name}"],
        ["Given Name", "#{last_name}"],
        ["Date of Birth", "#{date_of_birth}"],
        ["Class", "#{school_class.name}"],
        ["Matricule", "#{matricule}"],
      ] :
        [
        ["Father's name", "#{fathers_name}"],
        ["Father's cont", "#{fathers_contact}"],
        ["Mother's name", "#{mothers_name}"],
        ["Mother's cont", "#{mothers_contact}"],
        ["Other cont", "#{guidance_name}"],
        ["Other cont", "#{guidance_contact}"],
        ["School cont", "+#{@school.phone_number}"],
      ]

      # Indent to shift the table to the right (20% of the PDF width)
      @pdf.indent(@pdf.bounds.width * 0.3) do
        @pdf.table(personal_info, column_widths: column_widths,
                                  cell_style: { size: 9, valign: :center, align: :left })
      end
    end
  end
end
