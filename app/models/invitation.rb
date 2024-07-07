class Invitation < ApplicationRecord
  belongs_to :sender, class_name: "Teacher"
  belongs_to :teacher
  belongs_to :school

  validates :teachers_phone_number, presence: true, length: { minimum: 9 }
  enum status: { pending: 0, rejected: 1, accepted: 2 }

  before_validation :check_teachers_phone_number_existence

  private

  def check_teachers_phone_number_existence
    # Sanitize the input to remove any unwanted characters
    sanitized_phone_number = ActiveRecord::Base.sanitize_sql_like(teachers_phone_number)
    # Query the database with the sanitized input
    teacher = Teacher.where("phone_number LIKE ?", "%#{sanitized_phone_number}%").first
    self.teacher_id = teacher.id if teacher.present?
    errors.add(:teachers_phone_number, "does not exist on our 
      platform, please ask them to create an account.") unless teacher
  end
end
