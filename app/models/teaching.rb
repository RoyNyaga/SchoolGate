class Teaching < ApplicationRecord
  belongs_to :teacher
  belongs_to :subject
  belongs_to :school_class

  validates :teacher_id, presence: true, uniqueness: { scope: :subject,
                                                       message: ": Has already been assigned to this subject." }
end
