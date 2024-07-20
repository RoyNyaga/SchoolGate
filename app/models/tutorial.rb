class Tutorial < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  validates :priority, presence: true
  validates :title, uniqueness: true

  def list_title
    "#{priority} - #{title}"
  end
end
