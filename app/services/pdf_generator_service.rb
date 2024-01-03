class PdfGeneratorService
  attr_accessor :report_cards

  def initialize(report_cards)
    @pdf = Prawn::Document.new
    # @document_width = @pdf.bounds.width
    @report_cards = report_cards
    @school = School.find(report_cards.first.school_id)
  end

  def table_head
    ["", "<b>subject</b>", "<b>Seq1</b>", "<b>Seq2</b>", "<b>Avg/20</b>", "<b>Coef</b>", "<b>Score</b>", "<b>Grads</b>", "<b>Rank</b>", "<b>Teacher</b>", "<b>Remark</b>"]
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

      table << ["", "", "", "", "Total", report_card.total_coefficient, report_card.total_score, "", "", "", ""]

      @pdf.bounding_box([2, 730], width: 550, height: 650) do
        @pdf.move_down 10
        @pdf.font "Times-Roman" do
          @pdf.text @school.full_name, size: 13, style: :bold, align: :center
        end

        @pdf.font("Courier") do
          @pdf.text "Ministry Of Secondary Education", align: :center
          @pdf.text "P.O BOX 423 Tiko", align: :center
        end

        @pdf.float do
          @pdf.move_down 7
          @pdf.bounding_box([150, @pdf.cursor], width: 250) do
            @pdf.stroke_horizontal_rule
            @pdf.font "Times-Roman" do
              @pdf.pad(7) { @pdf.text "STUDENT PROGRESS REPORT", size: 10, style: :bold, align: :center }
            end
            @pdf.stroke_horizontal_rule
          end
        end

        @pdf.move_down 40

        @pdf.font "Times-Roman" do
          @pdf.pad(7) { @pdf.text "<b>Name Of Student:</b> #{report_card.student.full_name.upcase}", size: 10, inline_format: true, indent_paragraphs: 10 }
        end

        @pdf.stroke_horizontal_rule
        @pdf.font "Times-Roman" do
          @pdf.pad(5) { @pdf.text report_card.term.term_type.humanize.titleize, align: :center, size: 13, style: :bold }
        end

        @pdf.table(table, width: 549, cell_style: { :font => "Times-Roman", :size => 10, inline_format: true, inline_format: true })

        @pdf.move_down 30
        @pdf.table([
          ["Terminal Average", "#{report_card.average.round(2)} / 20"],
          ["Rank", "#{report_card.rank} Out of #{report_cards.count}"],
          ["Class Average", "#{report_card.class_average.round(2)} / 20"],
        ])
        @pdf.stroke_horizontal_rule
        @pdf.table([
          ["1st Term Average #{report_card.average.round(2)} / 20 \n Passed In  #{report_card.passed_subjects} subjects",
           "2nd Term Average #{report_card.average.round(2)} / 20 \n Passed In  #{report_card.passed_subjects} subjects",
           "3rd Term Average #{report_card.average.round(2)} / 20 \n Passed In  #{report_card.passed_subjects} subjects"],
        ], :width => 549)

        nested_table = @pdf.make_table([
          [{ :content => "<b>Disciplinary Records</b>", :colspan => 4 }],
          ["Absences", "___", "Attended DIS", "___"],
          ["Warned", "___", "Suspended", "___"],
          ["Might be Expelled", "___", "Expelled", "___"],
        ], cell_style: { :font => "Times-Roman", :size => 10, inline_format: true })

        @pdf.table([
          [nested_table, "Class Council Decision", "Class Master's Signature", "Principal's Remarks & Signature"],
        ], :width => 549, cell_style: { :font => "Times-Roman", :font_style => :italic })

        @pdf.transparent(1) { @pdf.stroke_bounds }
      end
      @pdf.start_new_page
    end

    @pdf
  end
end
