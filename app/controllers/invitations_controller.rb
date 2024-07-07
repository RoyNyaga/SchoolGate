class InvitationsController < ApplicationController
  before_action :set_invitation, only: [:accept, :reject]
  before_action :check_for_current_school, only: [:create]

  def new
    @invitation = Invitation.new
    render layout: "school_layout"
  end

  # POST /invitations or /invitations.json
  def create
    @invitation = Invitation.new(invitation_params)
    binding.break
    @teacher = Teacher.find_by(phone_number: params[:invitation][:teachers_phone_number])
    if @teacher && current_school.workers.where(id: @teacher.id).present?
      @status = "accepted"
      flash[:warning] = "This teacher is already a worker in this school"
      redirect_to invitations_schools_path(status: @status)
    else
      respond_to do |format|
        if @invitation.save
          format.html { redirect_to invitations_schools_path(status: "pending"), success: "invitation was successfully created." }
        else
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    end
  end

  def accept
    @invitation.update(status: Invitation.statuses["accepted"])
    unless current_school.workers.where(teacher_id: @invitation.teacher.id).present?
      Working.create(school_id: @invitation.school_id,
                     teacher_id: @invitation.teacher_id,
                     permission: @invitation.permission,
                     agreed_salary: @invitation.proposed_salary,
                     job_description: @invitation.job_description)
    end

    flash[:success] = "Successfully Accepted Invitation"
    @status = "pending"
    redirect_to invitations_teachers_path(status: @status)
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
    params.require(:invitation).permit(:school_id, :teacher_id, :sender_id, :permission, :proposed_salary, :job_description, :teachers_phone_number)
  end
end
