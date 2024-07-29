ActiveAdmin.register School do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :teacher_id, :full_name, :abbreviation, :education_level, :approval_state, :environment_mode,
                :student_id_settings, :whatsapp_notification_settings, :town, :address, :moto

  index do
    selectable_column
    id_column
    column :full_name
    column :teacher_name do |school|
      if school.teacher
        link_to school.teacher.full_name, admin_teacher_path(school.teacher)
      else
        "No Teacher Assigned"
      end
    end
    column :education_level
    column :town
    column :approval_state
    column :environment_mode
    actions
  end

  filter :full_name
  filter :teacher_id
  filter :education_level
  filter :approval_state
  filter :environment_mode
  filter :town

  form do |f|
    f.inputs do
      f.input :education_level
      f.input :approval_state
      f.input :environment_mode
      f.input :town
      f.input :address
      f.input :abbreviation
    end
    f.actions
  end

  controller do
    def scoped_collection
      super.includes(:teacher) # Include the teacher association to avoid N+1 queries
    end
  end
end
