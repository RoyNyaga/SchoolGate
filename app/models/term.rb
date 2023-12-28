class Term < ApplicationRecord
  belongs_to :school
  has_many :sequences
  has_many :report_cards

  enum term_type: { first_term: 1, second_term: 2, third_term: 3 }
end
