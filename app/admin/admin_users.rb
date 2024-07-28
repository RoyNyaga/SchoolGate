ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation, :phone_number, :name

  index do
    selectable_column
    id_column
    column :name
    column :phone_number
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :name
  filter :phone_number
  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :name
      f.input :phone_number
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
