class School < ApplicationRecord
  belongs_to :teacher
  has_many :school_classes, dependent: :destroy
  has_many :students, dependent: :destroy
  has_many :subjects, dependent: :destroy
  has_many :workings, dependent: :destroy
  has_many :workers, through: :workings, dependent: :destroy, source: "teacher"
  has_many :invitations, dependent: :destroy
  has_many :sequences, dependent: :destroy
end
