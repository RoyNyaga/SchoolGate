class PdfGeneratorService
  attr_accessor :report_cards

  def initialize(report_cards)
    @pdf = Prawn::Document.new
    # @document_width = @pdf.bounds.width
    @report_cards = report_cards
    @school = School.find(report_cards.first.school_id)
  end

  def table_head
    ["", "subject", "Seq1", "Seq2", "Avg/20", "Coef", "Score", "Grads", "Rank", "Teacher", "Remark"]
  end

  def add_subject_info
  end

  def parse_subject_info(subject_info)
    subject_info.map { |s| eval(s) }
  end

  def generate_pdf
    @report_cards.each do |report_card|
      table = [] << table_head
      subject_info = parse_subject_info(report_card.details)
      subject_info.each_with_index do |info, index|
        table << [index + 1, info[:name], info[:first_seq_mark], info[:second_seq_mark], info[:average_mark], info[:coefficient], info[:score], info[:grade], info[:rank], info[:teacher], "Very Good"]
      end

      @pdf.bounding_box([2, 730], width: 550, height: 650) do
        @pdf.move_down 10
        @pdf.text @school.full_name, size: 15, style: :bold, align: :center
        @pdf.text "Ministry Of Secondary Education", align: :center
        @pdf.text "P.O BOX 423 Tiko", align: :center
        @pdf.float do
          @pdf.move_down 7
          @pdf.bounding_box([150, @pdf.cursor], width: 250) do
            @pdf.stroke_horizontal_rule

            @pdf.pad(7) { @pdf.text "STUDENT PROGRESS REPORT", size: 11, style: :bold, align: :center }
            @pdf.stroke_horizontal_rule
          end
        end
        @pdf.move_down 40
        @pdf.table(table)
        @pdf.transparent(1) { @pdf.stroke_bounds }
      end
      @pdf.start_new_page
    end

    @pdf
  end
end
