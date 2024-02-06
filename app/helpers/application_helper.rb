module ApplicationHelper
  def generate_modal_id(type, record: nil)
    action_name.strip.downcase.gsub(" ", "-")
    if record
      "#{record.class.name.downcase}_#{type}_modal_#{record.id}"
    else
      "#{type}_modal"
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
end
