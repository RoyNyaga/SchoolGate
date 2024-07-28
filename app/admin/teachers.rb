ActiveAdmin.register Teacher do
  permit_params :email, :password, :password_confirmation, :remember_created_at, :phone_number, :full_name, :first_name, :last_name, :town

  index do
    selectable_column
    id_column
    column :phone_number
    column :full_name
    column :first_name
    column :last_name
    column :created_at
    actions
  end

  filter :email
  filter :phone_number
  filter :full_name
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
