include ActionView::Helpers::NumberHelper

class PdfSequenceBasedGeneratorService
  attr_accessor :report_cards, :file_name

  def initialize(report_card: nil, report_card_generator: nil, is_bulk_create: false)
    @pdf = Prawn::Document.new
    if is_bulk_create
      # @document_width = @pdf.bounds.width
      @report_card_generator = report_card_generator
      @file_name = "#{@report_card_generator.title(with_school: true).gsub(" ", "_").gsub("-", "_").gsub("/", "_")}_#{@report_card_generator.id}.pdf"
      @report_cards = @report_card_generator.report_cards
      @school = @report_card_generator.school
      @term = @report_card_generator.term
      @school_class = @report_card_generator.school_class
      @academic_year = @report_card_generator.academic_year
    else
      @report_card = report_card
      @report_card_generator = report_card.report_card_generator
      @file_name = "#{@report_card.student.full_name.gsub(" ", "_")}.pdf"
      @school = @report_card.school
      @student = @report_card.student
      @term = @report_card.term
      @school_class = @report_card.school_class
      @academic_year = @report_card.academic_year
    end
  end

  def table_head
    ["", "<b>subject</b>", "<b>Seq1</b>", "<b>Seq2</b>", "<b>Avg/20</b>", "<b>Coef</b>", "<b>Score</b>", "<b>Grads</b>", "<b>Rank</b>", "<b>Teacher</b>", "<b>Remark</b>"]
  end

  def parse_subject_info(subject_info)
    subject_info.map { |s| eval(s) }
  end

  def generate_single_pdf(is_bulk_create: false)
    @pdf.bounding_box([2, 730], width: 550) do
      add_logo
      letter_head
      report_card_title
      subject_details
      # @pdf.move_down 10
      average_section
      desciplinary_section
    end

    if is_bulk_create
      @pdf.start_new_page
    else
      @pdf
    end
  end

  def generate_bulk_pdf
    @report_cards.each do |report_card|
      @report_card = report_card
      @student = report_card.student
      generate_single_pdf(is_bulk_create: true)
    end
    @pdf
  end

  def add_logo
    # Get the logo URL from ActiveStorage
    if @school.photo.attached?
      @logo = StringIO.open(@school.photo.download)
      @pdf.image @logo, fit: [70, 70], position: :center, at: [@pdf.bounds.width / 2.4, @pdf.cursor]
    end
  end

  def letter_head
    column_widths = [@pdf.bounds.width / 3.0] * 3 # Assuming 3 columns
    # get student fees for this class and academic year
    student_fee = @student.fees.find_by(school_class_id: @school_class.id, academic_year_id: @academic_year.id)
    content = [
      ["REPUBLIC OF CAMEROON
        Peace – Work – Fatherland
        *************
        MINISTRY OF SECONDARY EDUCATION
        *************
        #{@school.full_name.upcase}
       #{@school.address.downcase}
       Contact: #{@school.phone_number}
       ",

       "",

       "Student: #{@student.full_name.upcase}
        Matricule: #{@student.matricule}
        Gender: #{@student.gender}
        Class: #{@school_class.name}
        Year: #{@academic_year.year}
        Balance Fee: #{number_to_currency(student_fee.balance, unit: " ", precision: 0)} frs
     "],
    ]
    @pdf.table(content,
               cell_style: { borders: [], size: 9, valign: :center, align: :center },
               column_widths: column_widths) do
    end
  end

  def report_card_title
    @pdf.text "#{@term.term_type.humanize.upcase} PROGRESS RECORD", style: :bold, align: :center, size: 9
    @pdf.text "School Year: #{@term.academic_year.year}", align: :center, size: 9

    @pdf.move_down 8
  end

  def subject_details
    table_data = [] << ["", "<b>subject</b>", "<b>Seq1</b>", "<b>Seq2</b>", "<b>Avg/20</b>", "<b>Coef</b>", "<b>Score</b>", "<b>Grads</b>", "<b>Rank</b>", "<b>Teacher</b>", "<b>Remark</b>"]

    ReportCard.string_to_hash_arr(@report_card.details).each_with_index do |info, index|
      table_data << [index + 1, info["name"], info["first_seq_mark"], info["second_seq_mark"], info["average_mark"], info["coefficient"], info["score"], info["grade"], info["rank"], two_names(info["teacher"]), info["remark"]]
    end

    table_data << ["", "", "", "", "Total", @report_card.total_coefficient, @report_card.total_score, "", "", "", ""]

    @pdf.table(table_data, width: 549, cell_style: { :font => "Times-Roman", :size => 8, inline_format: true, inline_format: true })
  end

  def two_names(name)
    if name.present?
      name.split(" ")[0..1]
    end
  end

  def average_section
    @pdf.table([
      ["<b>Terminal Average</b>", "#{@report_card.average.round(2)} / 20"],
      ["<b>Rank</b>", "#{@report_card.rank} Out of #{@report_card.class_enrollment}"],
      ["<b>Class Average</b>", "#{@report_card.class_average.round(2)} / 20"],
    ], cell_style: { :font => "Times-Roman", :size => 9, inline_format: true })
    @pdf.table([
      ["1st Term Average #{@report_card.average.round(2)} / 20 \n Passed In  #{@report_card.passed_subjects} subjects",
       "",
       ""],
    ], width: 549, cell_style: { :font => "Times-Roman", :size => 9, inline_format: true })
  end

  def desciplinary_section
    nested_table = @pdf.make_table([
      [{ :content => "<b>Disciplinary Records</b>", :colspan => 4 }],
      ["Absences", "___", "Attended DIS", "___"],
      ["Warned", "___", "Suspended", "___"],
      ["Might be Expelled", "___", "Expelled", "___"],
    ], cell_style: { :font => "Times-Roman", :size => 9, inline_format: true })

    @pdf.table([
      [nested_table, "Class Council Decision", "Class Master's Signature", "Principal's Remarks & Signature"],
    ], :width => 549, cell_style: { :font => "Times-Roman", :size => 8, :font_style => :italic })
  end

  def save_file
    @pdf.render_file Rails.root.join("public", @file_name)
  end

  def access_file
    File.open Rails.root.join("public/#{@file_name}")
  end

  def delete_pdf_file
    file_path = Rails.root.join("public", @file_name)

    # Check if the file exists before attempting to delete it
    if File.exist?(file_path)
      File.delete(file_path)
      puts "PDF file deleted successfully."
    else
      puts "PDF file does not exist."
    end
  end
end
