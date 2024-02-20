class Topic < ApplicationRecord
  belongs_to :teacher
  belongs_to :main_topic
  belongs_to :subject

  enum progress: { to_do: 1, in_progress: 2, completed: 3 }

  after_update :update_main_topic

  # private

  def update_main_topic
    binding.break

    topic_progress_group_data = main_topic.topics.group(:progress).count
    total_topic_num = topic_progress_group_data.values.sum
    if topic_progress_group_data["completed"] > 0
      main_topic_percent_complete = (topic_progress_group_data[:completed] / total_topic_num).to_f * 100
      main_topic.update(percent_complete: main_topic_percent_complete,
                        is_complete: main_topic_percent_complete >= 100)
    end
  end
end
