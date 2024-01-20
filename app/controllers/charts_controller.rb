class ChartsController < ApplicationController
  def complete_incomplete_pie
    fees = Fee.all
    percentages = fees.calc_complete_and_incomplete_percent
    data = [["Complete", percentages[:complete_percent]], ["Incomplete", percentages[:incomplete_percent]]]
    render json: data
  end

  def incomplete_fee_per_installment_bar
    render json: Fee.incompleted.order(:installment_num).group(:installment_num).count
  end

  def complete_fee_per_installment_bar
    render json: Fee.completed.order(:installment_num).group(:installment_num).count
  end
end
