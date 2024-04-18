class Receipt < ApplicationRecord
  belongs_to :school
  belongs_to :teacher
  belongs_to :academic_year
  belongs_to :student
  belongs_to :fee

  def self.generate_transaction_reference
    "#{Fee.generate_time_stamp}#{Fee.generate_blob(12)}"
  end
end
