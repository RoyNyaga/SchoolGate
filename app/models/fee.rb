class Fee < ApplicationRecord
  include DataTrans
  include TimeManipulation

  belongs_to :school
  belongs_to :school_class
  belongs_to :student
  has_many :receipts

  validates :student_id, uniqueness: { scope: :school_class_id,
                                       message: "Two Fees can't exist for the same student in the same class" }
  validate :fee_not_above_required_fee

  enum installment_num: { no_payment: 0, first_installment: 1, second_installment: 2, third_installment: 3, forth_installment: 4,
                          fifth_installment: 5, sith_installment: 6 }

  before_save :set_other_field_values
  after_update do
    create_receipt
    register_student
  end

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
    school_class.required_fee
  end

  def balance
    required_fee - total_fee_paid
  end

  def calc_percentage_complete
    percent = (total_fee_paid.to_f / required_fee.to_f) * 100
    percent.round(2)
  end

  def self.academic_year_list_per_school(current_school)
    current_school.fees.group(:academic_year_id).count.keys
  end

  def required_fee
    school_class.required_fee.to_i
  end

  private

  def fee_not_above_required_fee
    errors.add(:installment, "total fee paid is above the required class fee which is 
    #{required_fee} 
    fcfa. We hope you know what you are doing?, please visit the class edit page to update the required fee.") if calc_total_fees > required_fee
  end

  def create_receipt
    all_update_records = Fee.string_to_hash_arr(update_records)
    last_update_record = all_update_records.last
    last_update_record_amounts = last_update_record[:changes] # [10000, 20000, 40000]
    last_created_receipt = receipts.order(id: :asc).last

    if last_created_receipt.present? # when fee has existing receipts
      update_history = last_created_receipt.update_history
      update_history_amounts = update_history["changes"] # get the amount changes recorded in the last receipt that was created etc [2000, 4000]
      changed_amounts = values_in_a_not_in_b(last_update_record_amounts, update_history_amounts)
      changed_amounts.each do |amount|
        receipt = Receipt.create(school_id: school_id, teacher_id: last_update_record[:updator_id], academic_year_id: academic_year_id,
                                 student_id: student_id, fee_id: id, transaction_reference: Receipt.generate_transaction_reference,
                                 update_history: last_update_record, amount: amount.to_f, total_fees_paid_at_this_point: self.total_fee_paid,
                                 installment_num: self.installment_num)

        FeesAlertWhatsappJob.perform_later(receipt.id, ["principal", "buster"], "fees_instant_pay_template")
        FeesAlertWhatsappJob.perform_later(receipt.id, ["principal", "buster"], "school_fees_parent_receipt")
      end
    else
      last_update_record_amounts.each do |amount|
        receipt = Receipt.create(school_id: school_id, teacher_id: last_update_record[:updator_id], academic_year_id: academic_year_id,
                                 student_id: student_id, fee_id: id, transaction_reference: Receipt.generate_transaction_reference,
                                 update_history: last_update_record, amount: amount.to_f, total_fees_paid_at_this_point: self.total_fee_paid,
                                 installment_num: self.installment_num)

        FeesAlertWhatsappJob.perform_later(receipt.id, ["principal", "buster"], "fees_instant_pay_template")
        FeesAlertWhatsappJob.perform_later(receipt.id, ["principal", "buster"], "school_fees_parent_receipt")
      end
    end

    receipt_amount = receipts.map(&:amount).sum
    is_receipt_in_phase = receipt_amount == total_fee_paid
    # use update_columns to avoid call_backs from being triggered
    update_columns(receipt_amount: receipt_amount, is_receipt_and_fee_amount_in_phase: is_receipt_in_phase)
  end

  def values_in_a_not_in_b(arr_a, arr_b)
    frequency_a = Hash.new(0)
    frequency_b = Hash.new(0)

    arr_a.each { |item| frequency_a[item] += 1 }
    arr_b.each { |item| frequency_b[item] += 1 }

    result = []

    frequency_a.each do |item, count|
      (count - frequency_b[item]).times { result << item }
    end

    result
  end

  def register_student
    if school.active_academic_year.id == academic_year_id
      student.update(is_registered: total_fee_paid > 0)
    end
  end
end
