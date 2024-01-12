class Fee < ApplicationRecord
  belongs_to :school
  belongs_to :school_class
  belongs_to :student

  validates :academic_year, presence: true
  validates :student_id, uniqueness: { scope: :school_class_id,
                                       message: "Two Fees can't exist for the same student in the same class" }
  validate :fee_not_above_required_fee

  enum installment_num: { no_installment: 0, first_installment: 1, second_installment: 2, third_installment: 3, forth_installment: 4,
                          fifth_installment: 5, sith_installment: 6 }

  before_save :set_other_field_values

  def set_other_field_values
    self.total_fee_paid = calc_total_fees
    self.is_completed = complete?
    seelf.installment_num = installments.count
  end

  def calc_total_fees
    installments.map(&:to_i).sum
  end

  def complete?
    total_fee_paid >= school.send(school_class.generate_fee_string).to_i
  end

  private

  def fee_not_above_required_fee
    required_fee = school.send(school_class.generate_fee_string)
    error.add(:installment, "total fee paid (#{total_fee_paid} fcfa) is above the required class fee which is 
    #{required_fee} 
    fcfa. We hope you know what you are doing?, please visit the school 
    seting page under school fees setting for this class to update this toal fee.") if total_fee_paid > required_fee
  end
end
