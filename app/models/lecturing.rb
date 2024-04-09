class Lecturing < ApplicationRecord
  belongs_to :course
  belongs_to :teacher

  validates :course_id, uniqueness: { scope: :teacher_id,
                              message: "This course has already been assigned to this teacher" }
end
