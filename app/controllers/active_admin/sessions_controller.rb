module ActiveAdmin
  class SessionsController < ActiveAdmin::Devise::SessionsController
    def after_sign_in_path_for(resource)
      admin_dashboard_path # or any other path you want to redirect to
    end

    def after_sign_out_path_for(resource_or_scope)
      new_admin_user_session_path # Redirect to the login page after sign-out
    end
  end
end
