class Curriculum < ApplicationRecord
  include TimeManipulation

  belongs_to :school
  belongs_to :school_class
  belongs_to :teacher
  belongs_to :subject
  has_many :main_topics

  validates :title, presence: true

  def self.update_completion_state(main_topic_ids)
    curriculums = Curriculum.joins(:main_topics).where(main_topics: { id: main_topic_ids }).distinct
    curriculums.each do |curriculum|
      curriculum_maintopic_group_data = curriculum.main_topics.group(:is_complete).count
      total_main_topic = curriculum_maintopic_group_data.values.sum
      if curriculum_maintopic_group_data[true].present? && curriculum_maintopic_group_data[true] > 0
        curriculum_percent_complete = (curriculum_maintopic_group_data[true] / total_main_topic).to_f * 100

        curriculum.update(is_complete: curriculum_percent_complete >= 100,
                          percent_complete: curriculum_percent_complete)
      end
    end
  end
end
