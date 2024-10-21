class SchoolClass < ApplicationRecord
  belongs_to :school
  has_many :students
  has_many :subjects
  has_many :sequences
  has_many :report_cards
  has_many :fees
  has_many :teachings
  has_many :teachers, through: :teachings
  has_many :competences

  validates :name, presence: true, uniqueness: { scope: :school_id,
                                                 message: ": Every Class Should be Unique" }

  validates :required_fee, presence: true
  before_save :name_to_lowercase

  enum report_card_format: { nursery_one_report_card_format: 0, nursery_two_report_card_format: 1,
                             primary_one_report_card_format: 2, primary_two_report_card_format: 3,
                             secondary_one_report_card_format: 4, secondary_two_report_card_format: 5 }

  default_scope { order(:level) }

  def generate_fee_string
    "level_#{level}_fees"
  end

  private

  def name_to_lowercase
    self.name = name.downcase
  end
end
