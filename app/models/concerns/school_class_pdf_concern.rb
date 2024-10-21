module SchoolClassPdfConcern
  extend ActiveSupport::Concern

  included do
    def generate_class_list(status: nil)
      @school = school
      @status = status
      @students = @status.present? ? students.send(status).order(full_name: :asc) : students
      @pdf = Prawn::Document.new

      add_school_logo_to_pdf
      letter_head
      add_students
      @pdf
    end

    def add_school_logo_to_pdf
      # Get the logo URL from ActiveStorage
      if @school.photo.attached?
        logo = StringIO.open(@school.photo.download)
        @pdf.image logo, fit: [50, 50], position: :center, at: [30, @pdf.bounds.top]
      end
    end

    def letter_head
      @pdf.indent(@pdf.bounds.width * 0.1) do
        @pdf.font "Times-Roman" do
          @pdf.text "#{@school.full_name} (#{@school.abbreviation})", size: 13, style: :bold, align: :center
        end
        @pdf.move_down 3
        @pdf.font("Courier") do
          @pdf.text "#{name.upcase} #{@status} Students Class List", align: :center, size: 10
          @pdf.move_down 3
        end
        @pdf.move_down 3
      end
    end

    def add_students
      @pdf.move_down 30
      table_header = [
        ["S/N", "Student Full Name", "Date of birth", "Sex", "Matricule", "Status"],
      ]

      column_widths = [
        @pdf.bounds.width * 0.08,  # SN
        @pdf.bounds.width * 0.37,  # full name
        @pdf.bounds.width * 0.2,  # Date of birth
        @pdf.bounds.width * 0.1,  # Sex
        @pdf.bounds.width * 0.15,  # Matricule
        @pdf.bounds.width * 0.1,  # Status
      ]

      count = 0
      student_data = @students.map do |student|
        ["#{count += 1}", "#{student.full_name}", "#{student.date_of_birth}", "#{student.gender}", "#{student.matricule}", "#{student.status}"]
      end
      table_data = table_header + student_data
      @pdf.table(table_data, column_widths: column_widths,
                             cell_style: { inline_format: true, size: 10, valign: :center, align: :center, overflow: :shrink_to_fit }) do
        row(0).font_style = :bold  # Make the header bold
      end
    end
  end
end
