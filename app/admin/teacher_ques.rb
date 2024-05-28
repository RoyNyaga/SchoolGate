ActiveAdmin.register TeacherQue do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :full_name, :phone_number, :name_of_schools_taught, :location_of_schools, :education_level, :subjects_taught, :progress_importance, :most_usefull_feature, :comfort_in_filling_progress, :track_hours_usefulness, :online_report_cards, :referal
  #
  # or
  #
  # permit_params do
  #   permitted = [:full_name, :phone_number, :name_of_schools_taught, :location_of_schools, :education_level, :subjects_taught, :progress_importance, :most_usefull_feature, :comfort_in_filling_progress, :track_hours_usefulness, :online_report_cards, :referal]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
