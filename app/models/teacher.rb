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

  validates :phone_number, uniqueness: true

  before_save :set_full_name #This method is defined int he application_record

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
end
