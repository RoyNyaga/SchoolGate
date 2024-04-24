class ApplicationController < ActionController::Base
  helper_method :current_school, :is_student_logged_in?, :current_student
  protect_from_forgery with: :exception
  before_action :authenticate_teacher!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def current_school
    @current_school ||= School.find(session[:current_school_id]) if session[:current_school_id]
  end

  def set_current_school(school)
    session[:current_school_id] = school.id
  end

  def check_for_current_school
    unless session[:current_school_id]
      redirect_to schools_path
      return
    end
  end

  def log_in_student(student)
    cookies.permanent.signed[:logged_in_student_id] = student.id
  end

  def current_student
    @current_student ||= Student.find_by(id: cookies.signed[:logged_in_student_id]) if cookies.signed[:logged_in_student_id]
  end

  def is_student_logged_in?
    !current_student.nil?
  end

  def forget_student_cookies
    cookies.delete(:logged_in_student_id)
  end

  def forget_current_school_session
    session.delete(:current_school_id)
  end

  def log_out_student
    forget_student_cookies
    forget_current_school_session
    @current_school = nil
    @current_student = nil
  end

  def check_for_current_student
    if cookies.signed[:logged_in_student_id] #set current_school if student is singed in and school session is missing
      school = School.find_by(id: current_student.school_id)
      set_current_school(school)
    else
      redirect_to login_student_dashboards_path
    end
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[phone_number first_name last_name other_names address date_of_birth gender])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[phone_number first_name other_names address date_of_birth gender])
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[phone_number])
  end

  def after_sign_in_path_for(resource)
    # stored_location_for(resource) || schools_path
    schools_path
  end
end
