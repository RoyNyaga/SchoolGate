class TeachersController < ApplicationController
  before_action :set_teacher, only: [:edit]

  def invitations
    @pending = current_teacher.invitations.pending
    @accepted = current_teacher.invitations.accepted
    @rejected = current_teacher.invitations.rejected
  end

  def subjects
    @subjects = current_teacher.class_subjects
  end

  def edit
  end

  private

  def set_teacher
    @teacher = Teacher.find(params[:id])
  end
end
