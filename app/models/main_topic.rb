class MainTopic < ApplicationRecord
  belongs_to :teacher
  belongs_to :curriculum
  belongs_to :subject
  has_many :topics, dependent: :destroy
  # after_update :update_curriculum

  private

  def self.update_completion_state(main_topics)
    main_topics.each do |main_topic|
      topic_progress_group_data = main_topic.topics.group(:progress).count
      total_topic_num = topic_progress_group_data.values.sum
      if topic_progress_group_data["completed"].present? && topic_progress_group_data["completed"] > 0
        main_topic_percent_complete = (topic_progress_group_data["completed"] / total_topic_num).to_f * 100
        main_topic.update(percent_complete: main_topic_percent_complete,
                          is_complete: main_topic_percent_complete >= 100)
      end
    end
  end

  # def update_curriculum
  #   curriculum_maintopic_group_data = curriculum.main_topics.group(:is_complete).count
  #   total_main_topic = curriculum_maintopic_group_data.values.sum
  #   if curriculum_maintopic_group_data[true] > 0
  #     curriculum_percent_complete = (curriculum_maintopic_group_data[true] / total_main_topic).to_f * 100

  #     curriculum.update(is_complete: curriculum_percent_complete >= 100,
  #                       percent_complete: curriculum_percent_complete)
  #   end
  # end
end
