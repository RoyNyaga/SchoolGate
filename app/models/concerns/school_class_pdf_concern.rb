include ActionView::Helpers::NumberHelper

module SchoolClassPdfConcern
  extend ActiveSupport::Concern

  included do
    def generate_class_list(status: nil)
      @school = school
      @status = status
      @students = @status.present? ? students.send(status).order(full_name: :asc) : students.order(full_name: :asc)
      @pdf = Prawn::Document.new

      add_school_logo_to_pdf
      letter_head("Students Class List")
      add_students
      @pdf
    end

    def generate_fees_based_class_list
      @school = school
      @fees = fees
        .where(academic_year_id: school.active_academic_year.id)
        .includes(:school, :school_class, :student)
        .joins(:student)
        .order("students.full_name ASC")
      @pdf = Prawn::Document.new
      add_school_logo_to_pdf
      letter_head("Students Fees List \n Required Fee: #{number_to_currency(required_fee, unit: "frs", precision: 0, format: "%n %u")}")
      add_fees
      @pdf
    end

    def add_school_logo_to_pdf
      # Get the logo URL from ActiveStorage
      if @school.photo.attached?
        logo = StringIO.open(@school.photo.download)
        @pdf.image logo, fit: [50, 50], position: :center, at: [30, @pdf.bounds.top]
      end
    end

    def letter_head(title)
      @pdf.indent(@pdf.bounds.width * 0.1) do
        @pdf.font "Times-Roman" do
          @pdf.text "#{@school.full_name} (#{@school.abbreviation})", size: 13, style: :bold, align: :center
        end
        @pdf.move_down 3
        @pdf.font("Courier") do
          @pdf.text "#{name.upcase} #{@status} #{title}", align: :center, size: 10
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

    def add_fees
      @pdf.move_down 30
      table_header = [
        ["S/N", "Student Full Name", "Matricule", "Amount Paid", "Balance", "% completed"],
      ]

      column_widths = [
        @pdf.bounds.width * 0.08,  # SN
        @pdf.bounds.width * 0.35,  # full name
        @pdf.bounds.width * 0.15,  # Matricule
        @pdf.bounds.width * 0.15,   # amount paid
        @pdf.bounds.width * 0.15,   # Balance
        @pdf.bounds.width * 0.12,   # % complete
      ]

      count = 0
      fees_data = @fees.map do |fee|
        student = fee.student
        amount_paid = number_to_currency(fee.total_fee_paid, unit: "frs", precision: 0, format: "%n %u")
        balance_amount = number_to_currency(fee.balance, unit: "frs", precision: 0, format: "%n %u")

        ["#{count += 1}", "#{student.full_name}", "#{student.matricule}", "#{amount_paid}", "#{balance_amount}", "#{fee.percentage_complete} %"]
      end
      table_data = table_header + fees_data
      @pdf.table(table_data, column_widths: column_widths,
                             cell_style: { inline_format: true, size: 10, valign: :center, align: :center, overflow: :shrink_to_fit }) do
        row(0).font_style = :bold  # Make the header bold
      end
    end
  end
end
