class InvitationsController < ApplicationController
  before_action :check_for_current_school
  before_action :set_invitation, only: [:accept, :reject]

  def new
  end

  # POST /invitations or /invitations.json
  def create
    @invitation = Invitation.new(invitation_params)

    respond_to do |format|
      if @invitation.save
        format.html { redirect_to request.referer, notice: "invitation was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @invitation.errors, status: :unprocessable_entity }
      end
    end
  end

  def accept
    @invitation.update(status: Invitation.statuses["accepted"])
    Working.create(school_id: @invitation.school_id,
                   teacher_id: @invitation.teacher_id,
                   permission: @invitation.permission,
                   agreed_salary: @invitation.proposed_salary,
                   job_description: @invitation.job_description)

    flash[:success] = "Successfully Accepted Invitation"
    redirect_to request.referer
  end

  def reject
    @invitation.update(status: Invitation.statuses["rejected"])
    flash[:success] = "Successfully Rejected Invitation"
    redirect_to request.referer
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_invitation
    @invitation = Invitation.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def invitation_params
    params.require(:invitation).permit(:school_id, :teacher_id, :sender_id, :permission, :proposed_salary, :job_description)
  end
end
