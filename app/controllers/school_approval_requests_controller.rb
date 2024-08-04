class SchoolApprovalRequestsController < InheritedResources::Base
  layout "school_layout"
  before_action :check_for_current_school
  before_action :set_approval_request, only: [:edit]

  def new
    @school_approval_request = SchoolApprovalRequest.new
  end

  def edit
  end

  def create
    @approval_request = SchoolApprovalRequest.new(school_approval_request_params)

    respond_to do |format|
      if @approval_request.save
        content = "A School Approval Request Has been Submitted."
        SuperAdminWhatsappJob.perform_later("Super Admin Notification",
                                            admin_school_approval_request_path(@approval_request), content, "super_admin_notification_template")
        format.html { redirect_to school_path(current_school), notice: "Successfully submitted approval request." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_approval_request
    @approval_request = SchoolApprovalRequest.find_by(id: params[:id])
  end

  def school_approval_request_params
    params.require(:school_approval_request).permit(:school_id, :teacher_id, :school_name, :num_of_student, :education_level, :why_schoolgate, :town, :address, :how_did_you_know_about_us)
  end
end
