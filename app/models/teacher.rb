class Teacher < ApplicationRecord
  has_one_attached :photo
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :schools
  has_many :teachings, dependent: :destroy
  has_many :class_subjects, through: :teachings, source: "subject"
  has_many :workings, dependent: :destroy
  has_many :employers, through: :workings, dependent: :destroy, source: "school"
  has_many :invitations, dependent: :destroy
  has_many :sent_invitations, class_name: "Invitation", foreign_key: "sender_id"
  has_many :sequences, dependent: :destroy
  has_many :fees, dependent: :destroy
  has_many :curriculums, dependent: :destroy
  has_many :progresses, dependent: :destroy
  has_many :lecturings, dependent: :destroy
  has_many :courses, through: :lecturings
  has_many :assessments

  validates :first_name, presence: true
  validate :phone_number_digits_validation

  before_save :set_full_name #This method is defined int he application_record
  before_validation :set_phone_number
  after_create :notify_admins

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def will_save_change_to_email?
    false
  end

  def subjects_for_class(school_class)
    class_subjects.where(school_class_id: school_class.id)
  end

  def can_access_admin?(school)
    work = workings.where(school_id: school.id).first
    work.principal? || work.buster? || work.descipline_master?
  end

  def active_subjects
    class_subjects.joins(:teachings).where(teachings: { status: true })
  end

  def admin_content_notification_message
    "NEW TEACHER ALERT!!!!, We have a new teacher on the platform. full_name: #{self.full_name}, id: #{self.id}"
  end

  def format_phone_number
    if phone_number.length == 9
      return "237" + phone_number
    end
    return phone_number
  end

  private

  def notify_admins
    SuperAdminWhatsappJob.perform_later("Super Admin Notification",
                                        "/admin/teachers/#{id}", "New Account Notification: Teachers Name: #{full_name}", "super_admin_notification_template")
  end

  def set_phone_number
    self.phone_number = format_phone_number
  end

  def phone_number_digits_validation
    errors.add(:phone_number, "Must be 9 digits.") if self.phone_number.length != 12
  end
end
