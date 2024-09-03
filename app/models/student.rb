class Student < ApplicationRecord
  include TimeManipulation
  has_one_attached :photo

  belongs_to :school
  belongs_to :school_class
  has_many :report_cards
  has_many :fees, dependent: :destroy
  has_many :course_registrations
  has_many :enrollments, dependent: :destroy
  has_many :course_registrations

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

  after_update :update_fee_if_school_class_change

  enum status: { active: 0, dropout: 1, dismissed: 2 }

  delegate :name, to: :school_class, prefix: true

  enum education_level: { not_assigned: 0, basic_education: 1, secondary_education: 2, higher_education: 3 }
  enum gender: { female: 0, male: 1 }

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
    year = school.active_academic_year
    fees.create(school_id: school_id, school_class_id: school_class_id,
                academic_year_id: year.id, academic_year_text: year.year)
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

  def self.format_contact(name, contact, title)
    return nil if name.nil? || name.strip.empty? || contact.nil? || contact.strip.empty?

    # Prepend title and country code if necessary
    formatted_name = "#{title} #{name}"
    formatted_contact = contact.length <= 9 ? "237#{contact}" : contact

    { name: formatted_name, phone_number: formatted_contact }
  end

  def extract_contacts
    contacts = []

    # Process father's contact
    father_contact = Student.format_contact(self.fathers_name, self.fathers_contact, "Mr")
    contacts << father_contact if father_contact

    # Process mother's contact
    mother_contact = Student.format_contact(self.mothers_name, self.mothers_contact, "Mrs")
    contacts << mother_contact if mother_contact

    # Process guidance's contact
    guidance_contact = Student.format_contact(self.guidance_name, self.guidance_contact, "Mrs")
    contacts << guidance_contact if guidance_contact

    contacts
  end

  private

  def contact_check_for_higher_education_student
    if higher_education?
      errors.add(:contact, "Must be present") unless contact
    end
  end

  def update_fee_if_school_class_change
    if saved_change_to_school_class_id?
      fee = fees.where(academic_year_id: school.active_academic_year.id)
      if fee
        fee.update(school_class_id: school_class_id)
      end
    end
  end
end
