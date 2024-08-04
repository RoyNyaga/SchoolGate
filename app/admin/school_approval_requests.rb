ActiveAdmin.register SchoolApprovalRequest do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :school_id, :teacher_id, :school_name, :num_of_student, :education_level, :why_schoolgate, :town, :address, :how_did_you_know_about_us, :approval_state, :integer
end
