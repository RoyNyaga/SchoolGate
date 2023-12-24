class Invitation < ApplicationRecord
  belongs_to :sent_by, class_name: "teacher"
  belongs_to :teacher
  belongs_to :school

  enum status: { pending: 0, rejected: 1, accepted: 2 }

end
