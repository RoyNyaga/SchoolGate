class SubscriptionAcademicYear < ApplicationRecord
  validates :year, presence: true

  enum status: { active: 0, transition: 1, fulfilled: 2 }
end
