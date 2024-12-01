module PerformanceSheetPdfConcern
  extend ActiveSupport::Concern

  included do
    def generate_sheet
      @school = school
      @parsed_performance_date = PerformanceSheet.string_to_hash_arr(performance_data)
      @pdf = Prawn::Document.new(page_layout: :landscape)

      add_logo
      letter_head
      @pdf.move_down 15

      @pdf.text "#{@school.full_name} - #{school.abbreviation}", style: :bold, align: :center, size: 14

      @pdf.text "#{title}", style: :bold, align: :center, size: 10
      @pdf.move_down 15

      school_class_info
      @pdf.move_down 15

      add_body_data
      @pdf
    end

    def add_logo
      # Get the logo URL from ActiveStorage
      if @school.photo.attached?
        @logo = StringIO.open(@school.photo.download)
        @pdf.image @logo, fit: [80, 80], position: :center, at: [@pdf.bounds.width / 2.4, @pdf.cursor]
      end
    end

    def letter_head
      column_widths = [@pdf.bounds.width / 3.0] * 3 # Assuming 3 columns
      content = [
        ["REPUBLIC OF CAMEROON
          Peace – Work – Fatherland
          *************
          MINISTRY OF SECONDARY EDUCATION
          *************
          ",
         "",
         "RÉPUBLIQUE DU CAMEROUN
          Paix – Travail – Patrie
          *************
          MINISTÈRE DES ENSEIGNEMENTS SECONDAIRES
          *************
          "],
      ]
      @pdf.table(content,
                 cell_style: { borders: [], size: 9, valign: :center, align: :center },
                 column_widths: column_widths) do
      end
    end

    def school_class_info
      # Define the width to occupy 50% of the PDF
      total_width = @pdf.bounds.width * 0.5

      # Define column widths: two columns, each occupying 50% of the total width
      column_widths = [total_width / 2, total_width / 2]
      # Define the personal information content (two columns, six rows)
      personal_info = [
        ["Class", "#{school_class.name}"],
        ["Number of Students", "#{student_num}"],
        ["number of students Above average", "#{passed_student_num}"],
        ["Number of students Bellow average", "#{student_num_below_avg}"],
        ["Percentage Success", "#{percentage_success} %"],
      ]

      # Indent to shift the table to the right (20% of the PDF width)
      @pdf.indent(@pdf.bounds.width * 0.2) do
        @pdf.table(personal_info,
                   column_widths: column_widths,
                   cell_style: { size: 10, valign: :center, align: :left })
      end
    end

    def add_body_data
      subjects = @parsed_performance_date.first["subject_marks"].map { |s| s["subject_name"][0..2] }
      table_header = [
        ["S/N", "St Name", "Matricule", "Birth"] + subjects + ["Average"],
      ]
      count = 0
      data = @parsed_performance_date.map do |performance|
        ["#{count += 1}", "#{performance["student_name"]}", "#{performance["matricule"]}", "#{performance["date_of_birth"]}"] + performance["subject_marks"].map { |s| s["mark"] } + [performance["total_avg_mark"]]
      end
      table_data = table_header + data
      @pdf.table(table_data,
                 cell_style: { inline_format: true, size: 8, valign: :center, align: :center, overflow: :shrink_to_fit }) do
        row(0).font_style = :bold  # Make the header bold
      end
    end
  end
end
