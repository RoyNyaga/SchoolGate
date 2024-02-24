class ApplicationController < ActionController::Base
  helper_method :current_school
  protect_from_forgery with: :exception
  before_action :authenticate_teacher!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def current_school
    @current_school ||= School.find(session[:current_school_id]) if session[:current_school_id]
  end

  def check_for_current_school
    unless session[:current_school_id]
      redirect_to schools_path
      return
    end
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[phone_number first_name other_names address date_of_birth gender])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[phone_number first_name other_names address date_of_birth gender])
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[phone_number])
  end
end
