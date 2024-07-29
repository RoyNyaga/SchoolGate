ActiveAdmin.register School do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :teacher_id, :full_name, :abbreviation, :town, :address, :moto, :school_fees_settings, :student_id_settings, :education_level, :whatsapp_notification_settings
end
