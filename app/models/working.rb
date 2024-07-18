class Working < ApplicationRecord
  belongs_to :school
  belongs_to :teacher
  validates :school_id, uniqueness: { scope: :teacher_id,
                                      message: "This teacher is already a worker in this school" }

  enum permission: { teacher: 0, descipline_master: 1, buster: 2, principal: 3 }
  enum status: { active: 0, suspend: 1 }

  validates :permission, presence: true
end
