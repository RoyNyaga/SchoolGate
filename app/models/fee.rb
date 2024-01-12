class Fee < ApplicationRecord
  belongs_to :school
  belongs_to :school_class
  belongs_to :student

  validates :academic_year, presence: true
  validates :student_id, uniqueness: { scope: :school_class_id,
                                       message: "Two School Fees can't exist for the same class" }

  enum installment_num: { no_installment: 0, first_installment: 1, second_installment: 2, third_installment: 3, forth_installment: 4,
                          fifth_installment: 5, sith_installment: 6 }
end
