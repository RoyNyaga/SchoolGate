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
        sequence_performance if sequence_category?
      end

      @performance["total_avg_mark"] = (@performance["subject_marks"].sum { |subject| subject["mark"] } / @num_of_subjects).round(2)
      @data << @performance
    end
    @data = @data.sort_by { |student| -student["total_avg_mark"] }
    @data
  end

  def sequence_performance
    sequence = @subject.sequences.approved.where(term_id: @term.id, academic_year_id: @academic_year.id, seq_num: seq_num).first
    mark = @student.sequence_mark_per_subject(sequence.hashed_marks) || 0

    @performance["subject_marks"] << { "id" => @subject.id, "subject_name" => @subject.name, "mark" => mark }
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

  private

  def add_other_data
    performance_data = generate_performance_data
    student_num = @students.size
    passed_student_num = performance_data.count { |student| student["total_avg_mark"] >= 10 }

    # Update the model's attributes without calling save
    self.performance_data = performance_data
    self.student_num = student_num
    self.passed_student_num = passed_student_num
  end
end
