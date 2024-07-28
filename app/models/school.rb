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

  validates :full_name, presence: true, uniqueness: { scope: :teacher_id,
                                                      message: "You already have a school with this name" }
  validates :abbreviation, presence: true
  validates :moto, presence: true

  store_accessor :school_fees_settings, :level_1_fees, :level_2_fees, :level_3_fees, :level_4_fees,
                 :level_5_fees, :level_6_fees, :level_7_fees

  store_accessor :student_id_settings, :school_identifier
  store_accessor :whatsapp_notification_settings, :activate_notification, :notification_contact

  enum education_level: { basic_education: 1, secondary_education: 2, higher_education: 3 }

  scope :without_settings_attr, -> {
      select(:full_name, :id, :teacher_id, :abbreviation, :town,
             :address, :moto)
    }

  after_create :add_teachers_permission
  after_create :notify_admins
  before_create :set_school_identifier

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
    "NEW SCHOOL ALERT!!!!, The following school has been created #{self.full_name}"
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

  def notify_admins
    WhatsappNotificationJob.perform_later(self.id, "general_update_template", self.class.name)
  end
end
