class TeachersController < ApplicationController
  def invitations
    @pending = current_teacher.invitations.pending
    @accepted = current_teacher.invitations.accepted
    @rejected = current_teacher.invitations.rejected
    render layout: "school_layout"
  end
end
