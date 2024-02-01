class Student < ApplicationRecord
  include TimeManipulation
  has_one_attached :photo

  belongs_to :school
  belongs_to :school_class
  has_many :report_cards
  has_many :fees, dependent: :destroy

  after_create :create_fees
  before_save :set_full_name # this method is defined in the application_record

  def sequence_mark_per_subject(marks)
    mark = marks.find { |student| student["id"] == id.to_s }
    mark["mark"] unless mark.nil?
  end

  def rank_per_subject(marks)
    all_marks = marks.map { |mark| mark["mark"] }.uniq
    sequence_mark = sequence_mark_per_subject(marks)
    all_marks.index(sequence_mark) + 1
  end

  def sequence_rank(sequence_averages)
    mark = sequence_mark_per_subject(sequence_averages)
    arr = sequence_averages.map { |mark| mark["mark"] }.uniq.sort.reverse
    arr.index(mark) + 1
  end

  def create_fees
    fees.create(school_id: school_id, school_class_id: school_class_id, academic_year: Student.generate_current_academic_year)
  end
end
