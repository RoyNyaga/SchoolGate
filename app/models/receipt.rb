class Receipt < ApplicationRecord
  include TimeManipulation
  include ReceiptPdfConcern
  belongs_to :school
  belongs_to :teacher
  belongs_to :academic_year
  belongs_to :student
  belongs_to :fee

  enum installment_num: { no_payment: 0, first_installment: 1, second_installment: 2, third_installment: 3, forth_installment: 4,
                          fifth_installment: 5, sith_installment: 6 }

  def self.generate_transaction_reference
    "#{Fee.generate_time_stamp}#{Fee.generate_blob(12)}"
  end

  def balance
    fee.required_fee - total_fees_paid_at_this_point
  end

  def whatsapp_parent_header_message
    "Electronic Receipt from #{school.abbreviation}"
  end

  private
end
