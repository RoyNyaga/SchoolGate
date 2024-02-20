class Progress < ApplicationRecord
  include DataTrans

  belongs_to :school
  belongs_to :subject
  belongs_to :teacher
  belongs_to :term
  belongs_to :school_class

  validate :topics_presence

  enum seq_num: { first_sequence: 1, second_sequence: 2, third_sequence: 3, forth_sequence: 4, fifth_sequence: 5, sith_sequence: 6 }

  after_save :update_related_records

  def self.update_curriculum(topic_ids)
    main_topics = MainTopic.joins(:topics).where(topics: { id: topic_ids }).distinct
    MainTopic.update_completion_state(main_topics)
    main_topic_ids = main_topics.map(&:id)
    Curriculum.update_completion_state(main_topic_ids)
  end

  private

  def topics_presence
    errors.add(:topics, "Please provide the topics you taught today.") if self.topics.empty?
  end

  def update_related_records
    update_topic_progresses
    create_absences
  end

  def update_topic_progresses
    topics = Progress.string_to_hash_arr(self.topics)
    topics.each do |t|
      topic = Topic.find(t["id"].to_i)
      # using update_columns to avoid calling call methods so as to avoid issues.
      topic.update_columns(progress: t["progress"].to_i)
    end
  end

  def create_absences
    if created_at == updated_at # ensuring that we create absences only when a progress is beeing created
      students = Progress.string_to_hash_arr(self.absent_students)
      absences = students.map do |s|
        { school_id: self.school_id, student_id: s["id"].to_i, progress_id: self.id, term_id: self.term_id,
          academic_year: self.academic_year }
      end
      binding.break
      Absence.insert_all absences
    end
  end
end
