class Working < ApplicationRecord
  belongs_to :school
  belongs_to :teacher
  validates :school_id, uniqueness: { scope: :teacher_id, 
    message: "This teacher is already a worker to this school" }
end
