class MainTopic < ApplicationRecord
  belongs_to :teacher
  belongs_to :curriculum
  belongs_to :subject
  has_many :topics, dependent: :destroy
end
