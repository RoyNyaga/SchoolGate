class Sequence < ApplicationRecord
  belongs_to :school
  belongs_to :school_class
  belongs_to :teacher

  enum type: { first_sequence: 1, second_sequence: 2, third_sequence: 3 }
end
