class ReportCardGenerator < ApplicationRecord
  include DataTrans
  has_one_attached :report_card_file
  belongs_to :academic_year
  belongs_to :school_class
  belongs_to :term
  belongs_to :school
  has_many :report_cards

  enum progress_state: { initializing: 0, report_card_creation: 1, generating_pdf: 2, attach_pdf_to_generator: 3, completed: 4 }
  enum evaluation_method: { sequence_based_evaluation_method: 0, competence_based_evaluation_method: 1, primary_report_card_format: 2,
                            nursery_report_card_format: 3 }

  validate :student_presence_check

  delegate :year, to: :academic_year
  delegate :name, to: :school_class
  delegate :term_type, to: :term

  def title(with_school: false)
    with_school ? "#{name} - #{term_type} - #{year} - #{school.full_name}" : "#{name} - #{term_type} - #{year}"
  end

  def success_rate
    rate = (student_passed_num.to_f / student_num.to_f) * 100
    rate.round(2)
  end

  def format_process_duration
    "#{process_duration.round(2)} seconds"
  end

  def self.generate_school_class_report_cards(report_card_generator)
    @school = report_card_generator.school
    if @school.secondary_education?
      if report_card_generator.competence_based_evaluation_method?
        competence_based_evaluation_method_format(report_card_generator)
      else
        sequence_based_evaluation_method_format(report_card_generator)
      end
    elsif @school.basic_education?
      if report_card_generator.primary_report_card_format?
        primary_report_card_format(report_card_generator)
      elsif report_card_generator.nursery_report_card_format?
        nursery_report_evaluation_format(report_card_generator)
      end
    end
  end

  def self.competence_based_evaluation_method_format(report_card_generator)
    @report_card_generator = report_card_generator
    start_time = Time.now
    @school_class = @report_card_generator.school_class
    @school = @school_class.school
    @term = @report_card_generator.term
    @academic_year = @report_card_generator.academic_year
    @students = @school_class.students
    @subjects = @school_class.subjects
    @bulk_report = []
    @failed_errors = []
    @has_unapproved_sequence = false
    @warning_messages = []
    @enrollment = @school_class.students.active.size
    check_sequences_status
    unless @has_unapproved_sequence
      @students.each do |student|
        next unless student.active?
        total_score = 0
        total_coefficient = 0
        report_card_object = { school_id: @school.id, school_class_id: @school_class.id, term_id: @term.id,
                               student_id: student.id, academic_year_id: @academic_year.id,
                               report_card_generator_id: @report_card_generator.id, evaluation_method: 1 }
        details = []
        passed_subjects = 0
        @subjects.each do |subject|
          subject_detail = {}
          sequence = subject.sequences.approved.where(term_id: @term.id, academic_year_id: @academic_year.id).first
          if sequence.present?
            sequence_marks = sequence.hashed_marks
            if student.was_enrolled?(sequence_marks)
              student_marks = student.get_mark_object(sequence_marks)
              competences_mark = student_marks["competences"] # an array of competence object
              total_coefficient += subject.coefficient
              average_mark = (student_marks["mark"]).round(2)
              score = (average_mark * subject.coefficient).round(2)
              total_score += score
              passed_subjects += 1 if average_mark >= 10 # assuming that we are working on 20. In the future, passed mark could be a setting at the level of the school and class
              subject_detail["name"] = subject.name
              subject_detail["id"] = subject.id
              subject_detail["competences"] = competences_mark
              subject_detail["average_mark"] = average_mark
              subject_detail["coefficient"] = subject.coefficient
              subject_detail["score"] = score
              subject_detail["grade"] = "To Do"
              subject_detail["teacher"] = sequence.teachers_name
              subject_detail["remark"] = subject.add_remarks(average_mark)
              # binding.break
              details << subject_detail.to_s
            else
              @warning_messages << generate_warning_message("Missing enrollment for student #{student.full_name}", sequence, sequence.seq_title(with_class_name: false))
            end
          else
            @failed_errors << generate_error_message("Missing Sequence for subject #{subject.title}", subject, subject.title)
          end
        end

        report_card_object[:total_score] = total_score
        report_card_object[:total_coefficient] = total_coefficient
        report_card_object[:average] = total_coefficient > 0 ? (total_score / total_coefficient).round(2) : 0
        report_card_object[:passed_subjects] = passed_subjects
        report_card_object[:details] = details
        @bulk_report << report_card_object
      end
    end

    rank_report_card
    add_other_attributes

    if @failed_errors.present?
      process_duration = Time.now - start_time
      @report_card_generator.update(failed_errors: @failed_errors.uniq,
                                    warning_messages: @warning_messages.uniq, process_duration: process_duration,
                                    is_successful: false)
    else
      process_duration = Time.now - start_time
      reports_to_be_deleted = ReportCard.where(school_class_id: @school_class.id, term_id: @term.id, academic_year_id: @academic_year.id)
      reports_to_be_deleted.destroy_all if reports_to_be_deleted.present?
      ReportCard.insert_all @bulk_report
      @report_card_generator.update(is_successful: true, warning_messages: @warning_messages,
                                    process_duration: process_duration, student_num: @enrollment,
                                    student_passed_num: calc_student_passed_num, class_average: calc_class_average,
                                    most_performed_students: get_most_performed_students, failed_errors: @failed_errors,
                                    least_performed_students: get_least_performed_students)

      @report_card_generator.update(progress_state: 2)

      pdf_generator = PdfCompetenceBasedGeneratorService.new(report_card_generator: @report_card_generator, is_bulk_create: true)
      pdf_data = pdf_generator.generate_bulk_pdf
      file_name = pdf_generator.file_name
      @report_card_generator.update(progress_state: 3)
      pdf_generator.save_file
      pdf_path = pdf_generator.access_file
      @report_card_generator.report_card_file.attach(io: pdf_path, filename: file_name)
      pdf_generator.delete_pdf_file
      process_duration = Time.now - start_time
      @report_card_generator.update(progress_state: 4, process_duration: process_duration, is_processing: false)
    end
  end

  def self.sequence_based_evaluation_method_format(report_card_generator)
    @report_card_generator = report_card_generator
    start_time = Time.now
    @school_class = @report_card_generator.school_class
    @school = @school_class.school
    @term = @report_card_generator.term
    @academic_year = @report_card_generator.academic_year
    @students = @school_class.students
    @subjects = @school_class.subjects
    @bulk_report = []
    @failed_errors = []
    @has_unapproved_sequence = false
    @warning_messages = []
    @enrollment = @school_class.students.active.size

    begin
      check_sequences_status

      unless @has_unapproved_sequence
        @students.each do |student|
          next unless student.active?
          total_score = 0
          total_coefficient = 0
          report_card_object = { school_id: @school.id, school_class_id: @school_class.id, term_id: @term.id,
                                 student_id: student.id, academic_year_id: @academic_year.id, report_card_generator_id: @report_card_generator.id, evaluation_method: 0 }
          details = []
          passed_subjects = 0
          @subjects.each do |subject|
            subject_detail = {}
            first_seq, second_seq = subject.sequences.approved.where(term_id: @term.id, academic_year_id: @academic_year.id).order(:seq_num)
            if first_seq.present? && second_seq.present?
              if student.was_enrolled?(first_seq.hashed_marks) && student.was_enrolled?(second_seq.hashed_marks)
                sequence_marks = @term.sum_sequence_subject_marks(subject.id)
                sequence_averages = @term.calc_sequence_averages(sequence_marks)
                first_seq_mark = student.sequence_mark_per_subject(first_seq.hashed_marks)
                second_seq_mark = student.sequence_mark_per_subject(second_seq.hashed_marks)
                total_coefficient += subject.coefficient
                average_mark = (first_seq_mark + second_seq_mark) / 2
                score = average_mark * subject.coefficient
                total_score += score
                passed_subjects += 1 if average_mark >= 10 # assuming that we are working on 20. In the future, passed mark could be a setting at the level of the school and class
                subject_detail["name"] = subject.name
                subject_detail["id"] = subject.id
                subject_detail["first_seq_mark"] = first_seq_mark
                subject_detail["second_seq_mark"] = second_seq_mark
                subject_detail["average_mark"] = average_mark
                subject_detail["coefficient"] = subject.coefficient
                subject_detail["score"] = score
                subject_detail["grade"] = Subject.grading(average_mark)
                subject_detail["rank"] = student.sequence_rank(sequence_averages)
                subject_detail["teacher"] = second_seq.teachers_name
                subject_detail["remark"] = subject.add_remarks(average_mark)
                # binding.break
                details << subject_detail.to_s
              else
                [first_seq, second_seq].each do |s|
                  @warning_messages << generate_warning_message("Missing enrollment for student #{student.full_name}", s, s.seq_title(with_class_name: false)) unless student.was_enrolled?(s.hashed_marks)
                end
              end
            else
              @warning_messages << generate_warning_message("Missing Sequence for subject #{subject.title}", subject, subject.title)
            end
          end

          report_card_object[:total_score] = total_score
          report_card_object[:total_coefficient] = total_coefficient
          report_card_object[:average] = total_coefficient > 0 ? (total_score / total_coefficient) : 0
          report_card_object[:passed_subjects] = passed_subjects
          report_card_object[:details] = details
          @bulk_report << report_card_object
        end
      end

      rank_report_card
      add_other_attributes

      process_duration = Time.now - start_time
      reports_to_be_deleted = ReportCard.where(school_class_id: @school_class.id, term_id: @term.id, academic_year_id: @academic_year.id)
      reports_to_be_deleted.destroy_all if reports_to_be_deleted.present?
      ReportCard.insert_all @bulk_report
      @report_card_generator.update(is_successful: true, warning_messages: @warning_messages.uniq,
                                    process_duration: process_duration, student_num: @enrollment,
                                    student_passed_num: calc_student_passed_num, class_average: calc_class_average,
                                    most_performed_students: get_most_performed_students, failed_errors: @failed_errors,
                                    least_performed_students: get_least_performed_students)

      @report_card_generator.update(progress_state: 2)

      pdf_generator = PdfSequenceBasedGeneratorService.new(report_card_generator: @report_card_generator, is_bulk_create: true)
      pdf_data = pdf_generator.generate_bulk_pdf
      file_name = pdf_generator.file_name
      @report_card_generator.update(progress_state: 3)
      pdf_generator.save_file
      pdf_path = pdf_generator.access_file
      @report_card_generator.report_card_file.attach(io: pdf_path, filename: file_name)
      pdf_generator.delete_pdf_file
      process_duration = Time.now - start_time
      @report_card_generator.update(is_processing: false, progress_state: 4, process_duration: process_duration, is_successful: true)
    rescue => exception
      p exception
      process_duration = Time.now - start_time
      @report_card_generator.update(is_processing: false, process_duration: process_duration, is_successful: false)
    end
  end

  def self.nursery_report_evaluation_format(report_card_generator)
    @report_card_generator = report_card_generator
    start_time = Time.now
    @school_class = @report_card_generator.school_class
    @school = @school_class.school
    @term = @report_card_generator.term
    @academic_year = @report_card_generator.academic_year
    @students = @school_class.students
    @subjects = @school_class.subjects
    @bulk_report = []
    @failed_errors = []
    @has_unapproved_sequence = false
    @warning_messages = []
    @enrollment = @school_class.students.active.size

    begin
      check_sequences_status

      unless @has_unapproved_sequence
        @students.each do |student|
          next unless student.active?
          report_card_object = { school_id: @school.id, school_class_id: @school_class.id, term_id: @term.id,
                                 student_id: student.id, academic_year_id: @academic_year.id,
                                 report_card_generator_id: @report_card_generator.id, evaluation_method: 3 }
          details = []
          @subjects.each do |subject|
            subject_detail = {}
            sequence = subject.sequences.approved.find_by(term_id: @term.id, academic_year_id: @academic_year.id)
            mark = student.sequence_mark_per_subject(sequence.hashed_marks)

            if sequence.present?
              if student.was_enrolled?(sequence.hashed_marks)
                subject_detail["name"] = subject.name
                subject_detail["id"] = subject.id
                subject_detail["mark"] = mark
                subject_detail["teacher"] = sequence.teachers_name
                # binding.break
                details << subject_detail.to_s
              else
                [first_seq, second_seq].each do |s|
                  @warning_messages << generate_warning_message("Missing enrollment for student #{student.full_name}", s, s.seq_title(with_class_name: false)) unless student.was_enrolled?(s.hashed_marks)
                end
              end
            else
              @warning_messages << generate_warning_message("Missing Sequence for subject #{subject.title}", subject, subject.title)
            end
          end

          report_card_object[:details] = details
          @bulk_report << report_card_object
        end
      end

      process_duration = Time.now - start_time
      reports_to_be_deleted = ReportCard.where(school_class_id: @school_class.id, term_id: @term.id, academic_year_id: @academic_year.id)
      reports_to_be_deleted.destroy_all if reports_to_be_deleted.present?
      ReportCard.insert_all @bulk_report
      @report_card_generator.update(is_successful: true, warning_messages: @warning_messages.uniq,
                                    process_duration: process_duration, student_num: @enrollment, failed_errors: @failed_errors)

      @report_card_generator.update(progress_state: 2)

      pdf_generator = PdfSequenceBasedGeneratorService.new(report_card_generator: @report_card_generator, is_bulk_create: true)
      pdf_data = pdf_generator.generate_bulk_pdf
      file_name = pdf_generator.file_name
      @report_card_generator.update(progress_state: 3)
      pdf_generator.save_file
      pdf_path = pdf_generator.access_file
      @report_card_generator.report_card_file.attach(io: pdf_path, filename: file_name)
      pdf_generator.delete_pdf_file
      process_duration = Time.now - start_time
      @report_card_generator.update(is_processing: false, progress_state: 4, process_duration: process_duration, is_successful: true)
    rescue => exception
      p exception
      process_duration = Time.now - start_time
      @report_card_generator.update(is_processing: false, process_duration: process_duration, is_successful: false)
    end
  end

  def self.primary_report_card_format(report_card_generator)
    @report_card_generator = report_card_generator
    start_time = Time.now
    @school_class = @report_card_generator.school_class
    @school = @school_class.school
    @term = @report_card_generator.term
    @academic_year = @report_card_generator.academic_year
    @students = @school_class.students
    @subjects = @school_class.subjects
    @bulk_report = []
    @failed_errors = []
    @has_unapproved_sequence = false
    @warning_messages = []
    @enrollment = @school_class.students.active.size

    begin
      check_sequences_status

      unless @has_unapproved_sequence
        @students.each do |student|
          next unless student.active?
          total_average = 0
          subject_num = 0
          report_card_object = { school_id: @school.id, school_class_id: @school_class.id, term_id: @term.id,
                                 student_id: student.id, academic_year_id: @academic_year.id, report_card_generator_id: @report_card_generator.id, evaluation_method: 2 }
          details = []
          passed_subjects = 0
          @subjects.each do |subject|
            subject_detail = {}
            exam_result, test_result = subject.sequences.approved.where(term_id: @term.id, academic_year_id: @academic_year.id).order(:seq_num)
            if exam_result.present? && test_result.present?
              if student.was_enrolled?(test_result.hashed_marks) && student.was_enrolled?(exam_result.hashed_marks)
                subject_num += 1
                sequence_marks = @term.sum_sequence_subject_marks(subject.id)
                sequence_averages = @term.calc_sequence_averages(sequence_marks)
                test_result_mark = student.sequence_mark_per_subject(test_result.hashed_marks)
                exam_result_mark = student.sequence_mark_per_subject(exam_result.hashed_marks)
                average_mark = (test_result_mark + exam_result_mark) / 2
                total_average += average_mark
                passed_subjects += 1 if average_mark >= 10 # assuming that we are working on 20. In the future, passed mark could be a setting at the level of the school and class
                subject_detail["name"] = subject.name
                subject_detail["id"] = subject.id
                subject_detail["test_result_mark"] = test_result_mark
                subject_detail["exam_result_mark"] = exam_result_mark
                subject_detail["average_mark"] = (exam_result_mark + test_result_mark) / 2
                subject_detail["average_mark"] = average_mark
                subject_detail["grade"] = Subject.grading(average_mark)
                subject_detail["rank"] = student.sequence_rank(sequence_averages)
                subject_detail["teacher"] = exam_result.teachers_name
                subject_detail["remark"] = subject.add_remarks(average_mark)
                # binding.break
                details << subject_detail.to_s
              else
                [test_result, second_seq].each do |s|
                  @warning_messages << generate_warning_message("Missing enrollment for Pupil #{student.full_name}", s, s.seq_title(with_class_name: false)) unless student.was_enrolled?(s.hashed_marks)
                end
              end
            else
              @warning_messages << generate_warning_message("Missing test/exam for subject #{subject.title}", subject, subject.title)
            end
          end

          report_card_object[:average] = total_average.to_f / subject_num.to_f || 0
          report_card_object[:passed_subjects] = passed_subjects
          report_card_object[:details] = details
          @bulk_report << report_card_object
        end
      end

      rank_report_card
      add_other_attributes

      p @bulk_report
      process_duration = Time.now - start_time
      reports_to_be_deleted = ReportCard.where(school_class_id: @school_class.id, term_id: @term.id, academic_year_id: @academic_year.id)
      reports_to_be_deleted.destroy_all if reports_to_be_deleted.present?
      ReportCard.insert_all @bulk_report
      @report_card_generator.update(is_successful: true, warning_messages: @warning_messages.uniq,
                                    process_duration: process_duration, student_num: @enrollment,
                                    student_passed_num: calc_student_passed_num, class_average: calc_class_average,
                                    most_performed_students: get_most_performed_students, failed_errors: @failed_errors,
                                    least_performed_students: get_least_performed_students)

      @report_card_generator.update(progress_state: 2)

      pdf_generator = PdfPrimaryReportCardFormatService.new(report_card_generator: @report_card_generator, is_bulk_create: true)
      pdf_data = pdf_generator.generate_bulk_pdf
      file_name = pdf_generator.file_name
      @report_card_generator.update(progress_state: 3)
      pdf_generator.save_file
      pdf_path = pdf_generator.access_file
      @report_card_generator.report_card_file.attach(io: pdf_path, filename: file_name)
      pdf_generator.delete_pdf_file
      process_duration = Time.now - start_time
      @report_card_generator.update(is_processing: false, progress_state: 4, process_duration: process_duration, is_successful: true)
    rescue => exception
      p exception
      process_duration = Time.now - start_time
      @report_card_generator.update(is_processing: false, process_duration: process_duration, is_successful: false)
    end
  end

  def self.generate_warning_message(title, object, object_name)
    { "title" => title, "class_name" => object.class.name, "object_name" => object_name, "id" => object.id }
  end

  def self.generate_error_message(title, object, object_name)
    { "title" => title, "class_name" => object.class.name, "object_name" => object_name, "id" => object.id }
  end

  def self.check_sequences_status
    sequences = @school_class.sequences.where(academic_year_id: @academic_year.id, term_id: @term.id)
    unless sequences.all? { |s| s.approved? }
      @has_unapproved_sequence = true
      unapproved_seq = sequences.select { |s| !s.approved? }
      unapproved_seq.each do |s|
        @warning_messages << generate_warning_message("Unapproved Sequence for #{s.seq_title(with_class_name: true)}", s, s.seq_title(with_class_name: true))
      end
    end
  end

  def self.rank_report_card
    averages = @bulk_report.map { |r| r[:average] }.uniq.sort.reverse
    # binding.break
    @bulk_report.each { |r| r[:rank] = averages.index(r[:average]) + 1 }
  end

  def self.calc_student_passed_num
    @bulk_report.select { |r| r[:average] >= 10 }.count
  end

  def self.calc_success_rate
    rate = (calc_student_passed_num.to_f / @enrollment.to_f) * 100
    rate.round(2)
  end

  def self.sort_reports_increasing_order #1,2,3,4,5
    @bulk_report.sort_by { |r| r[:average] }
  end

  def self.sort_reports_decreasing_order # 5,4,3,2,1
    @bulk_report.sort_by { |r| -r[:average] }
  end

  def self.get_most_performed_students
    sort_reports_decreasing_order[0..4]
  end

  def self.get_least_performed_students
    sort_reports_increasing_order[0..4]
  end

  def self.calc_class_average
    class_avg = @bulk_report.map { |r| r[:average] }.sum / @bulk_report.size
    class_avg.round(2)
  end

  # def self.add_class_average
  #   @bulk_report.each { |r| r[:class_average] = calc_class_average }
  # end

  def self.add_other_attributes
    average = calc_class_average
    student_pased_num = calc_student_passed_num
    success_rate = calc_success_rate
    @bulk_report.each do |report|
      report[:class_average] = average
      report[:class_enrollment] = @enrollment
      report[:student_passed_num] = student_pased_num
      report[:success_rate] = success_rate
    end
  end

  def self.error_name_list(error_code)
    error_names = [{ "error_code" => "unapproved_seq", "message" => "Unapproved Sequence" },
                   { "error_code" => "missing_seq", "message" => "Missing Sequence for subject" }]
    error_object = error_names.find { |e| e["error_code"] == error_code }
    error_object
  end

  private

  def student_presence_check
    errors.add(:student_number, "Can't generate Report Card for a Class that has no student") if school_class.students.blank?
  end
end
