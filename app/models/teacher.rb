class Teacher < ApplicationRecord
  has_one_attached :photo
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :schools
  has_many :teachings
  has_many :class_subjects, through: :teachings, source: "subject"
  has_many :workings
  has_many :employers, through: :workings, source: "school"
  has_many :invitations, dependent: :destroy
  has_many :sent_invitations, class_name: "Invitation", foreign_key: "sender_id"
  has_many :sequences
  has_many :fees
  has_many :curriculums
  has_many :progresses
  has_many :lecturings
  has_many :courses, through: :lecturings
  has_many :assessments

  validates :first_name, presence: true
  validates :phone_number, uniqueness: {
                             message: "An account with this phone number already exist.",
                           }
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
    work&.principal? || work&.buster? || work&.descipline_master?
  end

  def active_subjects
    class_subjects.joins(:teachings).where(teachings: { status: true })
  end

  def admin_content_notification_message
    "NEW TEACHER ALERT!!!!, We have a new teacher on the platform. full_name: #{self.full_name}, id: #{self.id}"
  end

  private

  def notify_admins
    SuperAdminWhatsappJob.perform_later("Super Admin Notification",
                                        "/admin/teachers/#{id}", "New Account Notification: Teachers Name: #{full_name}", "super_admin_notification_template")
  end
end
