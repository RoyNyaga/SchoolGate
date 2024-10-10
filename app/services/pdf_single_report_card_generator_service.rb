class PdfSingleReportCardGeneratorService
  attr_accessor :report_card, :file_name

  def initialize(report_card)
    @pdf = Prawn::Document.new
    @report_card = report_card
    @report_card_generator = report_card.report_card_generator
    @file_name = "#{@report_card.student.full_name.gsub(" ", "_")}.pdf"
    @school = @report_card.school
    @student = @report_card.student
    @term = @report_card.term
  end

  def generate_pdf
    # Add logo first
    add_logo

    # Define the column widths to ensure equal sizes
    letter_head

    @pdf.move_down 10

    @pdf.text "#{@term.term_type.humanize.upcase} PROGRESS RECORD", style: :bold, align: :center, size: 10
    @pdf.text "School Year: #{@term.academic_year.year}", align: :center, size: 10

    student_personal_info
    @pdf.move_down 10

    report_card_body
    body_ending

    @pdf.move_down 10

    decipline_section_header
    decipline_section_body
    @pdf
  end

  def add_logo
    # Get the logo URL from ActiveStorage
    if @school.photo.attached?
      @logo = StringIO.open(@school.photo.download)
      @pdf.image @logo, fit: [80, 80], position: :center, at: [@pdf.bounds.width / 2.4, @pdf.cursor]
    end
  end

  def decipline_section_header
    column_widths = [@pdf.bounds.width / 3.0] * 3 # Assuming 3 columns
    content = [
      ["Discipline", "Student performance", "Class profile"],
    ]
    @pdf.table(content,
               cell_style: { size: 9, valign: :center, align: :center },
               column_widths: column_widths) do
    end
  end

  def nested_two_cols(col_one, col_two)
    @pdf.make_table([[col_one, " " * 17], [col_two, "" * 17]], cell_style: { size: 8, borders: [:top, :bottom, :left] })
  end

  def nested_one_col(col_one)
    @pdf.make_table([[col_one, " " * 17]], cell_style: { size: 8, borders: [:left] })
  end

  def decipline_section_body
    content = [
      ["Unjustified Abs. (h)", "", "Conduct Warning", "", "TOTAL SCORE", "#{@report_card.total_score}", "REMARK", "Class Average", "#{@report_card.class_average}"],
      ["Justified Abs. (h)", "", "Reprimand", "", "Coef", "", nested_two_cols("CVWA", "CWA"), "[Min - Max]", ""],
      ["Late", "", "Suspension", "", "Term average", "#{@report_card.average}", nested_two_cols("CA ", "CAA..."), "Number Passed", ""],
      ["Punishment", "", "", "", "Grade", "", nested_one_col("CNA..."), "Success rate (%)", ""],
    ]
    column_widths = [
      @pdf.bounds.width * 0.13, # abs
      @pdf.bounds.width * 0.05, # space
      @pdf.bounds.width * 0.103, # conduct
      @pdf.bounds.width * 0.05, # space
      @pdf.bounds.width * 0.12, # total score
      @pdf.bounds.width * 0.06, # space
      @pdf.bounds.width * 0.154, # remark
      @pdf.bounds.width * 0.16, # class average
      @pdf.bounds.width * 0.173, # space

    ]

    @pdf.table(content,
               cell_style: { size: 9, valign: :center, align: :center },
               column_widths: column_widths) do
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
        REGIONAL DELEGATION OF….
        ********** ***
        DIVISIONAL DELEGATION….
        *************
        HIGH SCHOOL",
       "\n \n \n \n \n #{@student.matricule}",
       "RÉPUBLIQUE DU CAMEROUN
        Paix – Travail – Patrie
        *************
        MINISTÈRE DES ENSEIGNEMENTS SECONDAIRES
        *************
        DÉLÉGATION RÉGIONALE DE …
        *************
        DÉLÉGATION DÉPARTEMENTALE DE…
        **************
        LYCÉE DE………"],
    ]
    @pdf.table(content,
               cell_style: { borders: [], size: 9, valign: :center, align: :center },
               column_widths: column_widths) do
    end
  end

  def student_personal_info
    # Define the width to occupy 80% of the PDF
    total_width = @pdf.bounds.width * 0.8

    # Define column widths: two columns, each occupying 50% of the total width
    column_widths = [total_width / 2, total_width / 2]
    date_of_birth_genger = [["", "Gender: "]]
    # Define the personal information content (two columns, six rows)
    personal_info = [
      ["Name of student: #{@student.full_name}", "Class: #{@student.school_class.name}"],
      ["Date and place of birth: #{@student.date_of_birth}", "Class enrollment: #{@report_card_generator.student_num}"],
      ["Gender: #{@student.gender}", "Number of subjects: #{@report_card.details.size}"],
      ["Repeater: Yes - No", "Number passed: #{@report_card.passed_subjects}"],
      ["Parent - #{@student.report_card_contact}", "Class master:"],
    ]

    # Indent to shift the table to the right (20% of the PDF width)
    @pdf.indent(@pdf.bounds.width * 0.2) do
      @pdf.table(personal_info,
                 column_widths: column_widths,
                 cell_style: { size: 10, valign: :center, align: :left })
    end
  end

  def body_ending
    data = [
      ["Total",
       "#{@report_card.total_coefficient}",
       "#{@report_card.total_score}",
       "AVERAGE: #{@report_card.average}"],
    ]

    column_widths = [
      @pdf.bounds.width * 0.62,  # AV/20
      @pdf.bounds.width * 0.06,  # Coef
      @pdf.bounds.width * 0.08,  # AV x coef
      @pdf.bounds.width * 0.24,   # Remarks and Teacher's signature
    ]

    @pdf.table(data,
               column_widths: column_widths,
               cell_style: { inline_format: true, size: 9, valign: :center, align: :center, overflow: :shrink_to_fit }) do
      row(0).font_style = :bold  # Make the header bold
    end
  end

  def report_card_body
    # Define the header of the table
    table_header = [
      ["<b>Subject and Teacher's Names</b>", "<b>Competences</b>", "<b>MK/20</b>", "<b>AV/20</b>",
       "<b>Coef</b>", "<b>AV x coef</b>", "<b>Grade</b>", "<b>[Min - Max]</b>", "<b>Remarks</b>"],
    ]

    # Define the column widths (customize as needed)
    column_widths = [
      @pdf.bounds.width * 0.13,  # Subject and Teacher's Names
      @pdf.bounds.width * 0.35,  # Competences
      @pdf.bounds.width * 0.07,  # MK/20
      @pdf.bounds.width * 0.07,  # AV/20
      @pdf.bounds.width * 0.06,  # Coef
      @pdf.bounds.width * 0.08,  # AV x coef
      @pdf.bounds.width * 0.07,  # Grade
      @pdf.bounds.width * 0.07,  # [Min - Max]
      @pdf.bounds.width * 0.10,   # Remarks and Teacher's signature
    ]

    # Table data for the report card
    table_data = ReportCard.string_to_hash_arr(@report_card.details).map do |subject|
      [
        "#{subject["name"]} \n #{subject["teacher"]}",                # Subject and Teacher
        competences_title(subject).join(",\n\n"),                        # Competences (formatted as a single string)
        competences_mark(subject).join("\n\n"),                         # MK/20 (using line breaks for marks)
        "#{subject["average_mark"]}",                                 # AV/20
        "#{subject["coefficient"]}",                                  # Coef
        "#{subject["score"]}",                                        # AV x coef
        "#{subject["grade"]}",                                        # Grade
        "",                                                           # [Min - Max]
        "#{subject["remark"]}",                                       # Remarks
      ]
    end

    # Combine the header and data
    complete_table = table_header + table_data

    # Generate the table
    @pdf.table(complete_table,
               column_widths: column_widths,
               cell_style: { inline_format: true, size: 9, valign: :center, align: :center, overflow: :shrink_to_fit }) do
      row(0).font_style = :bold  # Make the header bold
    end
  end

  # Competences summary (concatenate competences into one string with commas)
  def competences_title(subject)
    subject["competences"].map { |competence| competence["title"] }
  end

  # Competences marks (return marks as separate lines)
  def competences_mark(subject)
    subject["competences"].map { |competence| "#{competence["mark"]}" }
  end
end
