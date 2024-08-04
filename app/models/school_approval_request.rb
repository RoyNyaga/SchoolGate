class SchoolApprovalRequest < ApplicationRecord
  belongs_to :school
  belongs_to :teacher

  after_save :update_school_approval_state

  enum approval_state: { no_approval: 0, in_review: 1, rejected_approval: 2, accepted_approval: 3 }

  private

  def update_school_approval_state
    if accepted_approval?
      school.update(approval_state: approval_state, environment_mode: "live_mode")
    else
      school.update(approval_state: approval_state)
    end

    content = if in_review?
        "Thanks for Submitting your school information for approval. We are currently reviewing you School, it usually takes 24hrs to 48hrs."
      elsif accepted_approval?
        "Congratulations!!!!! Your School has been approved, you can now add students and invite teachers to collaborate."
      end

    SchoolAdminWhatsappJob.perform_later(school_id, ["principal"], "school_approval_requests/#{id}?current_school_id=#{school_id}", content, "administrator_notification_template")
  end
end
