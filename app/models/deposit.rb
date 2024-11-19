class Deposit < ApplicationRecord
  belongs_to :school, dependent: :destroy
  belongs_to :teacher
  belongs_to :academic_year

  enum origin: { from_fees: 0, from_sportware: 1, from_host: 2, from_books: 3, from_donation: 4, from_others: 5 }
  enum approval: { pending_approval: 0, validated_approval: 1, rejected_approval: 3 }
end
