class SchoolClass < ApplicationRecord
  belongs_to :school

  validates :name, presence: true, uniqueness: { scope: :school_id, 
    message: ": Every Class Should be Unique" }
  validates :level, presence: true, uniqueness: { scope: :school_id, 
    message: ": Every Class should have a unique Level" }

  before_save :name_to_lowercase

  private

  def name_to_lowercase
    self.name = name.downcase
  end
end
