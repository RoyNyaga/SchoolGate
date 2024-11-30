module PerformanceSheetPdfConcern
  extend ActiveSupport::Concern

  included do
    def generate_sheet
      @school = school
      @term = term
      @academic_year = academic_year
      @parsed_performance_date = PerformanceSheet.string_to_hash_arr(performance_data)
      @pdf = Prawn::Document.new(page_layout: :landscape)

      add_body_data
      @pdf
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
