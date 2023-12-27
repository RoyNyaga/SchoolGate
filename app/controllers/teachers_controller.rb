class TeachersController < ApplicationController
  layout "school_layout"
  before_action :check_for_current_school

  def invitations
    @pending = current_teacher.invitations.pending
    @accepted = current_teacher.invitations.accepted
    @rejected = current_teacher.invitations.rejected
  end

  def subjects
    @subjects = current_teacher.class_subjects
  end

  private
end
