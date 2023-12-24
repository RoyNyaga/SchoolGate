class Working < ApplicationRecord
  belongs_to :school
  belongs_to :teacher
  validates :school_id, uniqueness: { scope: :teacher_id, 
    message: "This teacher is already a worker to this school" }

  enum permission: { teacher: 0, descipline_master: 1, buster: 2, principal: 3 }
  enum status: { active: 0, inactive: 1 }

end
