class ChartsController < ApplicationController
  before_action :set_fees, only: [:complete_incomplete_pie, :incomplete_fee_per_installment_bar, :complete_fee_per_installment_bar]

  def complete_incomplete_pie
    percentages = @fees.calc_complete_and_incomplete_percent
    data = [["Complete", percentages[:complete_percent]], ["Incomplete", percentages[:incomplete_percent]]]
    render json: data
  end

  def incomplete_fee_per_installment_bar
    render json: @fees.incompleted.order(:installment_num).group(:installment_num).count
  end

  def complete_fee_per_installment_bar
    render json: @fees.completed.order(:installment_num).group(:installment_num).count
  end

  def incomplete_fee_per_class
    data = {}
    @school_classes = current_school.school_classes
    @school_classes.each do |s_c|
      data["#{s_c.name}"] = s_c.fees.incompleted.count # fees should be in the context of the academic year selected
    end
    render json: data
  end

  def complete_fee_per_class
    data = {}
    @school_classes = current_school.school_classes
    @school_classes.each do |s_c|
      data["#{s_c.name}"] = s_c.fees.completed.count # fees should be in the context of the academic year selected
    end
    render json: data
  end

  def revenue_per_class_over_time_line_chart
    main_data = {}
    @school_classes = current_school.school_classes
    data = Charts::DataParsing.revenue_per_class_over_time(@school_classes)
    render json: data
  end

  private

  def set_fees
    @fees = Fee.where(academic_year: params[:academic_year])
  end
end
