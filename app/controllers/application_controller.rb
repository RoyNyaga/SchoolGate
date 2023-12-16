class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_teacher!
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[phone_number first_name other_names address date_of_birth gender])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[phone_number first_name other_names address date_of_birth gender])
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[phone_number])
  end
end
