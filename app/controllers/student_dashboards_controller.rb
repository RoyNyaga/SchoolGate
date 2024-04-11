class StudentDashboardsController < ApplicationController
  layout "student_dashboard_layout"
  skip_before_action :authenticate_teacher!
  before_action :check_for_current_student, except: [:login, :create_session]
  before_action :check_for_current_school, except: [:login, :create_session]

  def login
  end

  def destroy_session_path
    log_out_student
    flash[:success] = "Log out successfully"
    redirect_to login_student_dashboards_path
  end

  def index
  end

  def create_session
    @school = School.find_by(id: params[:school_id])
    @student = @school.students.find_by(matricule: params[:matricule])

    if @student && @student.portal_code == params[:portal_code]
      log_in_student(@student)
      set_current_school(@school)
      flash[:success] = "Log In Successfully"
      redirect_to student_dashboards_path
    else
      flash.now[:error] = "Wroung Password to access This school"
      # redirect_to login_student_dashboards_path
      render :login, status: :unprocessable_entity
    end
  end

  def course_registrations
    @course_registrations = current_student.course_registrations
  end
end

# student_dashboards_controller
