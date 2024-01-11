class Fee < ApplicationRecord
  belongs_to :school
  belongs_to :school_class
  belongs_to :teacher
  belongs_to :student

  enum installment_num: { no_installment: 0 first_installment: 1, second_installment: 2, third_installment: 3, forth_installment: 4,
                       fifth_installment: 5, sith_installment: 6 }
end
