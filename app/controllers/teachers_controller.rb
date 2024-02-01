class TeachersController < ApplicationController
  include ApplicationHelper # this is to enable us access the generate_modal_id helper method from this controller
  before_action :set_teacher, only: [:edit, :update_photo]

  def invitations
    @pending = current_teacher.invitations.pending
    @accepted = current_teacher.invitations.accepted
    @rejected = current_teacher.invitations.rejected
  end

  def subjects
    @subjects = current_teacher.class_subjects
    render layout: "school_layout"
  end

  def edit
  end

  def update_photo
    if @teacher.update(photo_params)
      render json: { image_url: url_for(@teacher.photo),
                     modal_id: generate_modal_id("photo_form", record: @teacher),
                     message: "Successfully Updated Photo", success: true }, status: :ok
    else
      render json: { message: @teacher.errors.full_messages, success: false }, status: :unprocessable_entity
    end
  end

  private

  def set_teacher
    @teacher = Teacher.find(params[:id])
  end

  def photo_params
    params.require(:student).permit(:photo)
  end
end
