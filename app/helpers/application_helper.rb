module ApplicationHelper
  def generate_modal_id(type, record: nil)
    if record
      "#{record.class.name.downcase}_#{type}_modal_#{record.id}"
    else
      "#{type}_modal"
    end
  end

  def generate_drawer_id(type, record: nil)
    if record
      "#{record.class.name.downcase}_#{type}_drawer_#{record.id}"
    else
      "#{type}_drawer"
    end
  end

  def generate_accordion_id(type, record: nil)
    if record
      "#{record.class.name.downcase}_#{type}_accordion_#{record.id}"
    else
      "#{type}_accordion"
    end
  end

  def custom_id_generator(type, record: nil)
    if record
      "#{record.class.name.downcase}_#{type}_#{record.id}_custom_id"
    else
      "#{type}_custom_id"
    end
  end

  def google_map_src
    "https://maps.googleapis.com/maps/api/js?key=#{ENV["GOOGLE_PLACES_API_KEY"]}&loading=async&libraries=places&callback=initAutocomplete"
  end

  def photo_action_name(record)
    record.photo.attached? ? "Change Photo" : "Upload Photo"
  end

  def generate_sidebar_expanded_div_id(link_name)
    "sidebar_classes_expand_#{link_name.gsub(" ", "-").downcase}"
  end

  def current_school_classes_link_data
    current_school.school_classes.map do |school_class|
      { name: school_class.name, path: school_class_path(school_class.id) }
    end
  end

  def current_school_teachers_link_data
    [
      { name: "Invitations", path: invitations_schools_path },
      { name: "Contracts", path: contracts_schools_path },
      { name: "Permissions", path: permissions_schools_path },
    ]
  end

  def current_school_report_cards_link_data
    [
      { name: "Auto Generate (bulk)", path: auto_generate_report_cards_path },
      { name: "Manually Create", path: manually_create_report_cards_path },
    ]
  end

  def current_teacher_subject_link_data
    current_teacher.class_subjects.where(school_id: current_school.id).map do |c_s|
      { name: c_s.name, path: for_teacher_subject_path(c_s) }
    end
  end
end
