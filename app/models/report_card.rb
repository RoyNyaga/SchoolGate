class ReportCard < ApplicationRecord
  include DataTrans
  belongs_to :school
  belongs_to :school_class
  belongs_to :term
  belongs_to :student

  def self.generate_school_class_report_cards(school_class_id, term_id)
    @school_class = SchoolClass.find(school_class_id)
    @school = @school_class.school
    @term = Term.find(term_id)
    @students = @school_class.students
    @subjects = @school_class.subjects
    @bulk_report = []
    @students.each do |student|
      total_score = 0
      total_coefficient = 0
      report_card_object = { school_id: @school.id, school_class_id: @school_class.id, term_id: @term.id, student_id: student.id }
      details = []
      passed_subjects = 0
      @subjects.each do |subject|
        subject_detail = {}
        first_seq, second_seq = @term.sequences.where(subject_id: subject.id).order(:seq_num)
        sequence_marks = @term.sum_sequence_subject_marks(subject.id)
        sequence_averages = @term.calc_sequence_averages(sequence_marks)
        first_seq_mark = student.sequence_mark_per_subject(first_seq.hashed_marks)
        second_seq_mark = student.sequence_mark_per_subject(second_seq.hashed_marks)
        total_coefficient += subject.coefficient
        average_mark = (first_seq_mark + second_seq_mark) / 2
        score = average_mark * subject.coefficient
        total_score += score
        passed_subjects += 1 if average_mark >= 10 # assuming that we are working on 20. In the future, passed mark could be a setting at the level of the school and class
        subject_detail[:name] = subject.name
        subject_detail[:first_seq_mark] = first_seq_mark
        subject_detail[:second_seq_mark] = second_seq_mark
        subject_detail[:average_mark] = average_mark
        subject_detail[:coefficient] = subject.coefficient
        subject_detail[:score] = score
        subject_detail[:grade] = "To Do"
        subject_detail[:rank] = student.sequence_rank(sequence_averages)
        subject_detail[:teacher] = subject.teachers.first.full_name
        subject_detail[:remark] = "Good"
        # binding.break
        details << subject_detail.to_s
      end

      report_card_object[:total_score] = total_score
      report_card_object[:total_coefficient] = total_coefficient
      report_card_object[:average] = (total_score / total_coefficient)
      report_card_object[:passed_subjects] = passed_subjects
      report_card_object[:details] = details
      @bulk_report << report_card_object
    end

    rank_report_card
    add_class_average
    @bulk_report

    ReportCard.insert_all @bulk_report
  end

  def self.rank_report_card
    averages = @bulk_report.map { |r| r[:average] }.uniq.sort.reverse
    # binding.break
    @bulk_report.each { |r| r[:rank] = averages.index(r[:average]) + 1 }
  end

  def self.add_class_average
    average = @bulk_report.map { |r| r[:average] }.sum / @bulk_report.size
    @bulk_report.each { |r| r[:class_average] = average }
  end

  def generate_chart_data
    arr = ReportCard.string_to_hash_arr(details)
    main_data = [
      { "name" => "first_seq_mark", "data" => {} },
      { "name" => "second_seq_mark", "data" => {} },
    ]
    arr.each do |subject, index|
      seq_obj = {
        "first_seq_mark_data" => { "#{subject[:name][0..3]}" => subject[:first_seq_mark] },
        "second_seq_mark_data" => { "#{subject[:name][0..3]}" => subject[:second_seq_mark] },
      }

      main_data.each_with_index do |obj, index|
        current_key = index == 0 ? "first_seq_mark_data" : "second_seq_mark_data"
        obj["data"] = obj["data"].merge(seq_obj[current_key])
      end
    end
    main_data
  end

  def long_title
    "#{term.term_type} #{term.academic_year} #{school_class.name}"
  end

  def details_for(subject)
    ReportCard.string_to_hash_arr(details).find { |d| d[:name] == subject.name }
  end
end
