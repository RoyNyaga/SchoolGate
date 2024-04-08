class Faculty < ApplicationRecord
  belongs_to :school
  has_many :departments

  validates :name, presence: true
end