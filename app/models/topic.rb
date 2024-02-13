class Topic < ApplicationRecord
  belongs_to :teacher
  belongs_to :main_topic
  belongs_to :subject
end
