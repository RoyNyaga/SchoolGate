class Progress < ApplicationRecord
  include DataTrans
  include TimeManipulation

  belongs_to :school
  belongs_to :subject
  belongs_to :teacher
  belongs_to :term
  belongs_to :school_class

  validates :duration, presence: true
  validate :topics_presence

  enum seq_num: { first_sequence: 1, second_sequence: 2, third_sequence: 3, forth_sequence: 4, fifth_sequence: 5, sith_sequence: 6 }

  after_save :update_related_records

  store_accessor :period_duration, :hours, :mins

  def self.update_curriculum(topic_ids)
    main_topics = MainTopic.joins(:topics).where(topics: { id: topic_ids }).distinct
    MainTopic.update_completion_state(main_topics)
    main_topic_ids = main_topics.map(&:id)
    Curriculum.update_completion_state(main_topic_ids)
  end

  def self.calc_total_time(progresses)
    duration = { hours: 0, mins: 0 }
    progresses.each do |progress|
      duration[:hours] += progress.duration.hour if progress.duration.present?
      duration[:mins] += progress.duration.min if progress.duration.present?
    end
    mins_to_hours = duration[:mins] / 60
    remaining_mins = duration[:mins] % 60
    duration[:hours] += mins_to_hours
    duration[:mins] = remaining_mins
    duration
  end

  def hours_mins_taught
    "#{duration.hour} Hrs : #{duration.min} Mins" if duration
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
      # using update_columns to avoid calling callback methods so as to avoid issues.
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
      Absence.insert_all absences
    end
  end
end
