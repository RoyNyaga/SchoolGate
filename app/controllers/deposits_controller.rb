class DepositsController < ApplicationController
  layout "school_layout"

  def index
  end

  private

  def deposit_params
    params.require(:deposit).permit(:school_id, :teacher_id, :origin, :approval, :amount, :description)
  end
end
