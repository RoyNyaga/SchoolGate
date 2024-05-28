ActiveAdmin.register ProprietorQue do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :full_name, :phone_number, :name_of_school, :location, :functionality_importance, :additional_features, :cost, :should_join_community, :education_level, :keeping_track_of_school_fees, :other_questions
  #
  # or
  #
  # permit_params do
  #   permitted = [:full_name, :phone_number, :name_of_school, :location, :functionality_importance, :additional_features, :cost, :should_join_community, :education_level, :keeping_track_of_school_fees, :other_questions]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
