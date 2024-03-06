class Student < ApplicationRecord
  include TimeManipulation
  has_one_attached :photo

  belongs_to :school
  belongs_to :school_class
  has_many :report_cards
  has_many :fees, dependent: :destroy

  before_create do
    generate_matricule
    create_fees
  end
  before_save :set_full_name # this method is defined in the application_record

  delegate :name, to: :school_class, prefix: true

  def sequence_mark_per_subject(marks) # marks should be hashed
    mark = get_mark_object(marks)
    mark["mark"] unless mark.nil?
  end

  def get_mark_object(marks)
    marks.find { |student| student["id"] == id.to_s }
  end

  def rank_per_subject(marks)
    all_marks = marks.map { |mark| mark["mark"] }.uniq
    sequence_mark = sequence_mark_per_subject(marks)
    all_marks.index(sequence_mark) + 1
  end

  def sequence_rank(sequence_averages)
    mark = sequence_mark_per_subject(sequence_averages)
    arr = sequence_averages.map { |mark| mark["mark"] }.uniq.sort.reverse
    arr.index(mark) + 1
  end

  def create_fees
    fees.create(school_id: school_id, school_class_id: school_class_id, academic_year: Student.generate_current_academic_year)
  end

  def student_number_code
    "%04d" % school.students.count # returns number in a thousand format
  end

  def current_year_abbreviation
    Time.now.strftime("%y")
  end

  def generate_matricule
    "#{current_year_abbreviation}#{school.school_identifier}#{student_number_code}".upcase
  end

  def all_classes_attended_ids
    previous_classes + [school_class_id]
  end

  def attended_academic_years
    fees.where("percentage_complete > 1").map(&:academic_year)
  end

  # def save_matricule
  #   update(matricule: generate_matricule)
  # end
end
