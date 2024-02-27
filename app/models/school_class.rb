class SchoolClass < ApplicationRecord
  belongs_to :school
  has_many :students, dependent: :destroy
  has_many :subjects, dependent: :destroy
  has_many :sequences, dependent: :destroy
  has_many :report_cards, dependent: :destroy
  has_many :fees, dependent: :destroy
  has_many :school_classes, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :school_id,
                                                 message: ": Every Class Should be Unique" }
  validates :level, presence: true, uniqueness: { scope: :school_id,
                                                  message: ": Every Class should have a unique Level" }

  before_save :name_to_lowercase

  def generate_fee_string
    "level_#{level}_fees"
  end

  private

  def name_to_lowercase
    self.name = name.downcase
  end
end
