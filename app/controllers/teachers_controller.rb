class TeachersController < ApplicationController
  include ApplicationHelper # this is to enable us access the generate_modal_id helper method from this controller
  before_action :set_teacher, only: [:edit, :update_photo]
  before_action :check_for_current_school, only: [:subjects, :progresses]

  def invitations
    @pending = current_teacher.invitations.pending
    @accepted = current_teacher.invitations.accepted
    @rejected = current_teacher.invitations.rejected
  end

  def subjects
    @subjects = current_teacher.class_subjects
    render layout: "school_layout"
  end

  def courses
    @courses = current_teacher.courses
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

  def progresses
    @progresses = current_teacher.progresses.where(school_id: current_school.id)
    @total_hours_mins_time = Progress.calc_total_time(@progresses)
    @topics_covered = @progresses.map { |p| p.topics.count }.sum
    @absentist_num = @progresses.map { |p| p.absent_students.count }.sum

    render layout: "school_layout"
  end

  private

  def set_teacher
    @teacher = Teacher.find(params[:id])
  end

  def photo_params
    params.require(:student).permit(:photo)
  end
end
