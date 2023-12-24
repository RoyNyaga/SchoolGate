class Teacher < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :schools
  has_many :teachings, dependent: :destroy
  has_many :class_subjects, through: :teachings, source: "subject"
  has_many :workings, dependent: :destroy
  has_many :employers, through: :workings, dependent: :destroy, source: "school"
  validates :phone_number, uniqueness: true

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
  
end
