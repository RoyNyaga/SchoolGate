class PdfPrimaryReportCardFormatService
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

  def generate_single_pdf(is_bulk_create: false)
    @pdf.bounding_box([2, 730], width: 550) do
      add_logo
      letter_head
      report_card_title
      subject_details
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
    balance = student_fee&.balance
    balance_text = balance ? "#{number_to_currency(balance, unit: " ", precision: 0)} frs" : "N/A"
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
        Balance Fee: #{balance_text} frs
     "],
    ]
    @pdf.table(content,
               cell_style: { borders: [], size: 10, valign: :center, align: :center },
               column_widths: column_widths) do
    end
  end

  def report_card_title
    @pdf.text "#{@term.term_type.humanize.upcase} PROGRESS RECORD", style: :bold, align: :center, size: 9
    @pdf.text "School Year: #{@term.academic_year.year}", align: :center, size: 10

    @pdf.move_down 8
  end

  def subject_details
    table_data = [] << ["", "<b>SUBJECT</b>", "<b>TEST/20</b>", "<b>EXAM/20</b>", "<b>AVG</b>", "<b>GRADE</b>", "<b>REMARK</b>"]

    ReportCard.string_to_hash_arr(@report_card.details).each_with_index do |info, index|
      table_data << [index + 1, trim_subject_name(info["name"]), info["test_result_mark"], info["exam_result_mark"], info["average_mark"], info["grade"], info["remark"]]
    end

    @pdf.table(table_data, width: 549, cell_style: { :font => "Times-Roman", :size => 10, inline_format: true, inline_format: true })
  end

  def trim_teachers_name(name)
    if name.present?
      name.length > 15 ? name.split(" ")[0] : name.split(" ")[0..1].join(" ")
    end
  end

  def trim_subject_name(name)
    if name.present?
      name.length > 25 ? name.split(" ")[0..1].join(" ") : name
    end
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
