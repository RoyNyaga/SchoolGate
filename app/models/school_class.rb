class SchoolClass < ApplicationRecord
  belongs_to :school
  has_many :students, dependent: :destroy
  has_many :subjects, dependent: :destroy
  has_many :sequences, dependent: :destroy
  has_many :report_cards, dependent: :destroy
  has_many :fees, dependent: :destroy
  has_many :teachings, dependent: :destroy
  has_many :teachers, through: :teachings

  validates :name, presence: true, uniqueness: { scope: :school_id,
                                                 message: ": Every Class Should be Unique" }

  validates :required_fee, presence: true
  before_save :name_to_lowercase

  def generate_fee_string
    "level_#{level}_fees"
  end

  private

  def name_to_lowercase
    self.name = name.downcase
  end
end
