class Fee < ApplicationRecord
  include TimeManipulation

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

  scope :completed, -> { where(is_completed: true) }
  scope :incompleted, -> { where(is_completed: false) }

  def self.installment_by_num(num)
    installments = { "1" => "First", "2" => "Second", "3" => "Third",
                     "4" => "Forth", "5" => "Fifth", "6" => "Sith" }
    installments[num.to_s]
  end

  def self.calc_complete_and_incomplete_percent
    complete = completed.count.to_f
    incomplete = incompleted.count.to_f
    total = complete + incomplete
    { complete_percent: ((complete / total) * 100).round(2), incomplete_percent: ((incomplete / total) * 100).round(2) }
  end

  def set_other_field_values
    self.total_fee_paid = calc_total_fees
    self.is_completed = complete?
    self.installment_num = installments.count
    self.percentage_complete = calc_percentage_complete
  end

  def calc_total_fees
    installments.map(&:to_i).sum
  end

  def complete?
    total_fee_paid >= required_fee
  end

  def required_fee
    school.send(school_class.generate_fee_string).to_i
  end

  def balance
    required_fee - total_fee_paid
  end

  def calc_percentage_complete
    percent = (total_fee_paid.to_f / school.send(school_class.generate_fee_string).to_f) * 100
    percent.round(2)
  end

  def self.academic_year_list_per_school(current_school)
    current_school.fees.group(:academic_year).count.keys
  end

  private

  def fee_not_above_required_fee
    required_fee = school.send(school_class.generate_fee_string).to_i
    errors.add(:installment, "total fee paid (#{total_fee_paid} fcfa) is above the required class fee which is 
    #{required_fee} 
    fcfa. We hope you know what you are doing?, please visit the school 
    seting page under school fees setting for this class to update this toal fee.") if calc_total_fees > required_fee
  end
end
