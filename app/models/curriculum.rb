class Curriculum < ApplicationRecord
  include TimeManipulation

  belongs_to :school
  belongs_to :school_class
  belongs_to :teacher
  belongs_to :subject
  has_many :main_topics

  validates :title, presence: true

  def self.update_completion_state(main_topic_ids)
    # binding.break
    curriculums = Curriculum.joins(:main_topics).where(main_topics: { id: main_topic_ids }).distinct
    curriculums.each do |curriculum|
      main_topics = curriculum.main_topics
      main_topics_percent_complete_sum = main_topics.map(&:percent_complete).sum
      if main_topics_percent_complete_sum > 0
        average_percent_completion = main_topics_percent_complete_sum / main_topics.count
        curriculum.update(is_complete: average_percent_completion >= 100,
                          percent_complete: average_percent_completion)
      end
    end
  end
end
