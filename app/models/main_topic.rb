class MainTopic < ApplicationRecord
  belongs_to :teacher
  belongs_to :curriculum
  belongs_to :subject
end
