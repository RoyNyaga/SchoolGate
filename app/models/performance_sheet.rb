class PerformanceSheet < ApplicationRecord
  include DataTrans
  include PerformanceSheetPdfConcern

  has_one_attached :sheet

  belongs_to :school
  belongs_to :academic_year
  belongs_to :teacher
  belongs_to :school_class
  belongs_to :term

  validates :category, presence: true

  enum seq_num: { first_sequence: 1, second_sequence: 2, third_sequence: 3, forth_sequence: 4,
                  fifth_sequence: 5, sith_sequence: 6, first_term_sequence: 7, second_term_sequence: 8, third_term_sequence: 9 }

  enum category: { sequence_category: 0, term_category: 1 }

  before_save :add_other_data

  def generate_performance_data
    # Reinitializing the errors
    self.sequences_with_issues = []
    self.subjects_with_issues = []
    @term = term
    @academic_year = academic_year
    @data = []
    @subjects = school_class.subjects
    @num_of_subjects = @subjects.size
    @students = school_class.students.active
    @students.each do |student|
      @student = student
      @performance = {}
      @performance["student_name"] = @student.full_name
      @performance["matricule"] = @student.matricule
      @performance["date_of_birth"] = @student.ddmmyy_format(date: @student.date_of_birth)
      @performance["gender"] = @student.gender
      @performance["subject_marks"] = []
      @subjects.each do |subject|
        @subject = subject
        sequence_category? ? sequence_performance : term_performance
      end
      total_score = @performance["subject_marks"].sum { |subject| subject["score"] }
      total_coefficient = @performance["subject_marks"].sum { |subject| subject["coef"] }
      total_avg_mark = total_score / total_coefficient
      @performance["total_avg_mark"] = total_avg_mark.round(2)
      @data << @performance
    end
    @data = @data.sort_by { |student| -student["total_avg_mark"] }
    @data
  end

  def sequence_performance
    sequence = @subject.sequences.where(term_id: @term.id, academic_year_id: @academic_year.id, seq_num: seq_num).first
    if sequence.present?
      if sequence.approved?
        @mark = @student.sequence_mark_per_subject(sequence.hashed_marks) || 0
        @coef = @subject.coefficient
        @score = @mark * @coef
        @performance["subject_marks"] << subject_marks_obj
      else
        sequences_with_issues << error_mess_obj(sequence)
      end
    else
      subjects_with_issues << error_mess_obj(@subject)
    end
  end

  def term_performance
    sequences = @subject.sequences.where(term_id: @term.id, academic_year_id: @academic_year.id).order(seq_num: :asc)
    total_mark = 0
    if sequences.size == 2
      sequences.each do |s|
        if s.approved?
          total_mark += @student.sequence_mark_per_subject(s.hashed_marks) || 0 # calculating the total mark for the two sequencces
        else
          sequences_with_issues << error_mess_obj(s)
        end
      end
      @mark = total_mark.to_f / 2 # getting the average of first and second sequence mark
      @coef = @subject.coefficient
      @score = @mark * @coef

      @performance["subject_marks"] << subject_marks_obj
    elsif sequences.size < 2
      subjects_with_issues << error_mess_obj(@subject)
    end
  end

  def error_mess_obj(resource)
    if resource.class.name == "Sequence"
      { "sequence_id" => resource.id, "message" => "Unapproved Sequence: #{resource.subject.name} #{resource.seq_title}" }
    elsif resource.class.name == "Subject"
      { "subject_id" => resource.id, "message" => "Missing Sequence for subject: #{resource.name}" }
    end
  end

  def subject_marks_obj
    { "id" => @subject.id, "subject_name" => @subject.name,
      "mark" => @mark, "coef" => @coef, "score" => @score }
  end

  def title
    if sequence_category?
      "#{seq_num.humanize} #{academic_year.year} Performance Sheet"
    else
      "#{term.term_type.humanize} #{academic_year.year} Performance Sheet"
    end
  end

  def student_num_below_avg
    student_num - passed_student_num
  end

  def percentage_success
    ((passed_student_num.to_f / student_num.to_f) * 100).round(2)
  end

  def issues_count
    sequences_with_issues.size + subjects_with_issues.size
  end

  private

  def add_other_data
    performance_data = generate_performance_data
    student_num = @students.size
    passed_student_num = performance_data.count { |student| student["total_avg_mark"] >= 10 }

    # Update the model's attributes without calling save
    self.performance_data = performance_data
    self.student_num = student_num
    self.passed_student_num = passed_student_num
    self.sequences_with_issues = sequences_with_issues.uniq
    self.subjects_with_issues = subjects_with_issues.uniq
  end
end
