class School < ApplicationRecord
  has_one_attached :photo

  belongs_to :teacher
  has_many :school_classes, dependent: :destroy
  has_many :students, dependent: :destroy
  has_many :subjects, dependent: :destroy
  has_many :workings, dependent: :destroy
  has_many :workers, through: :workings, dependent: :destroy, source: "teacher"
  has_many :invitations, dependent: :destroy
  has_many :sequences, dependent: :destroy
  has_many :terms, dependent: :destroy
  has_many :semesters, dependent: :destroy
  has_many :report_cards, dependent: :destroy
  has_many :fees, dependent: :destroy
  has_many :progresses, dependent: :destroy
  has_many :academic_years
  has_many :report_card_generators
  has_many :faculties
  has_many :departments
  has_many :courses
  has_one :school_approval_request

  validates :full_name, presence: true, uniqueness: { scope: :teacher_id,
                                                      message: "You already have a school with this name" }
  validates :abbreviation, presence: true
  validates :moto, presence: true
  validates :phone_number, presence: true
  validate :phone_number_digits_validation

  store_accessor :school_fees_settings, :level_1_fees, :level_2_fees, :level_3_fees, :level_4_fees,
                 :level_5_fees, :level_6_fees, :level_7_fees

  store_accessor :student_id_settings, :school_identifier

  enum education_level: { basic_education: 1, secondary_education: 2, higher_education: 3 }
  enum approval_state: { no_approval: 0, in_review: 1, rejected_approval: 2, accepted_approval: 3 }
  enum environment_mode: { testing_mode: 0, school_gate_testing_mode: 1, live_mode: 2 }
  delegate :full_name, to: :teacher, prefix: true

  scope :without_settings_attr, -> {
      select(:full_name, :id, :teacher_id, :abbreviation, :town,
             :address, :moto)
    }

  after_create :add_teachers_permission
  before_create :set_school_identifier
  before_validation :set_phone_number

  # listing associations here to avoid Ransack errors on activeadmin.
  # this prevents active admin from wanting to search the associations which leads to errors

  def self.random_capital_letters(length)
    letters = ("A".."Z").to_a
    letters.sample(length).join
  end

  def add_teachers_permission
    self.workings.create(teacher_id: teacher_id, permission: 3)
  end

  def active_academic_year
    academic_years.active.first
  end

  def active_semester
    semesters.active.first
  end

  def admin_content_notification_message
    "NEW SCHOOL ALERT!!!!, The following school has been created full_name: #{self.full_name}, id: #{self.id}"
  end

  def administrators(permissions) # Can be an arr off permission ["principal", "teacher"] or simple string "principal"
    Teacher.joins(:workings).where(workings: { school_id: id, permission: permissions, status: "active" })
  end

  def currency
    "FCFA"
  end

  def ministry_type_letter_head
    if education_level == "secondary_education"
      "Ministery Of Secondary Education"
    elsif education_level == "basic_education"
      "Ministry Of Basic Education"
    else
      "Ministry Of Higher Education"
    end
  end

  private

  def set_school_identifier
    @existing_identifiers = School.all.map(&:school_identifier)
    @letters = School.random_capital_letters(2)
    @count = 1
    while @existing_identifiers.include?(@letters)
      puts "Stock in the set_school_identifier loop"
      if @count < 676 # there are 676 possible combinations of 2 letters in the english alphabet.
        @letters = School.random_capital_letters(2)
      else # move to 3 combination if count is above 676
        @letters = School.random_capital_letters(3)
      end
      @count += 1
    end
    self.school_identifier = @letters
  end
end
