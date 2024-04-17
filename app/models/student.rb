class Student < ApplicationRecord
  include TimeManipulation
  has_one_attached :photo

  belongs_to :school
  belongs_to :school_class
  has_many :report_cards
  has_many :fees, dependent: :destroy
  has_many :course_registrations
  has_many :enrollments, dependent: :destroy

  validate :contact_check_for_higher_education_student

  before_create do
    generate_matricule
    generate_portal_code
  end

  after_create do
    create_fees
  end
  before_save do
    set_full_name
  end # this method is defined in the application_record
  enum status: { active: 0, dropout: 1, dismissed: 2 }

  delegate :name, to: :school_class, prefix: true

  enum education_level: { not_assigned: 0, basic_education: 1, secondary_education: 2, higher_education: 3 }

  def sequence_mark_per_subject(marks) # marks should be hashed
    mark = get_mark_object(marks)
    mark["mark"] unless mark.nil?
  end

  def assessment_mark_per_subject(marks) # marks should be hashed
    mark = get_mark_object(marks)
    mark["mark"] unless mark.nil?
  end

  def was_enrolled?(marks)
    mark = get_mark_object(marks)
    mark.nil? ? false : mark["is_enrolled"]
  end

  def get_mark_object(marks)
    marks.find { |student| student["id"] == id }
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
    fees.create(school_id: school_id, school_class_id: school_class_id, academic_year: school.active_academic_year)
  end

  def student_number_code
    "%04d" % school.students.count # returns number in a thousand format
  end

  def current_year_abbreviation
    Time.now.strftime("%y")
  end

  def generate_matricule
    self.matricule = "#{current_year_abbreviation}#{school.school_identifier}#{student_number_code}".upcase
  end

  def generate_portal_code
    self.portal_code = "12345"
  end

  def all_classes_attended_ids
    previous_classes + [school_class_id]
  end

  def attended_academic_years
    fees.where("percentage_complete > 1").map(&:academic_year)
  end

  def faculty
    Faculty.find(faculty_id)
  end

  def department
    Department.find(department_id)
  end

  private

  def contact_check_for_higher_education_student
    if higher_education?
      errors.add(:contact, "Must be present") unless contact
    end
  end
end
