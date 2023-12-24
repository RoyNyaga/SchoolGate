class InvitationsController < ApplicationController
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

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_invitation
    @invitation = invitation.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def invitation_params
    params.require(:invitation).permit(:school_id, :teacher_id, :sender_id, :permission, :proposed_salary, :job_description)
  end
end
