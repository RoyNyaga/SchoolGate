class SchoolClass < ApplicationRecord
  include TimeManipulation
  include SchoolClassPdfConcern

  belongs_to :school
  has_many :students
  has_many :subjects
  has_many :sequences
  has_many :report_cards
  has_many :fees
  has_many :teachings
  has_many :teachers, through: :teachings
  has_many :competences
  has_many :performance_sheets

  validates :name, presence: true, uniqueness: { scope: :school_id,
                                                 message: ": Every Class Should be Unique" }

  validates :required_fee, presence: true
  before_save :name_to_lowercase

  enum report_card_format: { nursery_report_card_format: 0, primary_report_card_format: 1, secondary_one_report_card_format: 2 }

  default_scope { order(:level) }

  def generate_fee_string
    "level_#{level}_fees"
  end

  def self.allowed_report_card_formats(school)
    if school.basic_education?
      report_card_formats.select { |key, _| key.include?("nursery") || key.include?("primary") }
    elsif school.secondary_education?
      report_card_format.select { |key, _| key.include?("secondary") }
    end
  end

  private

  def name_to_lowercase
    self.name = name.downcase
  end
end
