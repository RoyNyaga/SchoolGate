ActiveAdmin.register Student do
  permit_params :school_id, :school_class_id, :full_name, :fathers_name, :fathers_contact, :mothers_name, :mothers_contact, :guidance_name, :guidance_contact, :date_of_birth, :address, :subjects, :town, :matricule, :portal_code, :first_name, :last_name, :previous_classes, :contact, :status, :education_level, :faculty_id, :department_id, :gender, :is_registered

  filter :school_id
  filter :school_class_id
  filter :full_name
  filter :fathers_name
  filter :fathers_contact
  filter :mothers_name
  filter :mothers_contact
  filter :date_of_birth
  filter :matricule
  filter :first_name
  filter :last_name
  filter :education_level
  filter :is_registered
  filter :gender

  form do |f|
    f.inputs do
      f.input :school_id
      f.input :school_class_id
      f.input :full_name
      f.input :fathers_name
      f.input :fathers_contact
      f.input :mothers_name
      f.input :mothers_contact
      f.input :date_of_birth
      f.input :matricule
      f.input :first_name
      f.input :last_name
      f.input :education_level
      f.input :gender
      f.input :is_registered
    end
    f.actions
  end
end
