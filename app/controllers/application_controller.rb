class ApplicationController < ActionController::Base
  helper_method :current_school
  protect_from_forgery with: :exception
  before_action :authenticate_teacher!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def current_school
    @current_school ||= School.find(session[:current_school_id]) if session[:current_school_id]
  end

  # def current_school_classes_link_data
  #   @current_school.school_classes.map do |school_class|
  #     { name: school_class.name, path: school_class_path(school_class.id) }
  #   end
  # end

  # def current_school_teachers_link_data
  #   [
  #     { name: "Invitations", path: invitations_schools_path },
  #     { name: "Contracts", path: contracts_schools_path },
  #     { name: "Permissions", path: permissions_schools_path },
  #   ]
  # end

  # def current_school_report_cards_link_data
  #   [
  #     { name: "Auto Generate (bulk)", path: auto_generate_report_cards },
  #     { name: "Manually Create", path: manually_create_report_cards },
  #   ]
  # end

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
