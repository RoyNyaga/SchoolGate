class Topic < ApplicationRecord
  belongs_to :teacher
  belongs_to :main_topic
  belongs_to :subject

  enum progress: { to_do: 1, in_progress: 2, completed: 3 }
end
