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

  def photo_action_name(record, photo_type)
    record.photo.attached? ? "Change #{photo_type}" : "Upload #{photo_type}"
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

  def current_school_faculties_link_data
    current_school.faculties.map do |faculty|
      { name: faculty.name, path: faculty_path(faculty) }
    end
  end

  def current_school_faculties_link_data
    current_school.departments.map do |department|
      { name: department.name, path: department_path(department) }
    end
  end

  def current_school_report_cards_link_data
    [
      { name: "Auto Generate (bulk)", path: auto_generate_report_cards_path },
      { name: "Manually Create", path: manually_create_report_cards_path },
    ]
  end

  def current_teacher_subject_link_data
    current_teacher.active_subjects.where(school_id: current_school.id).map do |c_s|
      { name: c_s.name, path: for_teacher_subject_path(c_s) }
    end
  end

  def current_teacher_courses_link_data
    current_teacher.courses.where(school_id: current_school.id).map do |course|
      { name: course.short_title, path: for_lecturer_course_path(course) }
    end
  end

  def topic_progress_icon(topic)
    if topic.in_progress?
      fas_icon("check", class: "text-warning")
    elsif topic.completed?
      fas_icon("check-double", class: "text-success")
    end
  end

  def generate_years
    current_year = Date.today.year
    ["#{current_year - 1}/#{current_year}", "#{current_year}/#{current_year + 1}"]
  end

  def percentage_badge_color(percentage_complete)
    if percentage_complete <= 25
      "bg-secondary"
    elsif percentage_complete <= 50
      "bg-warning"
    elsif percentage_complete <= 75
      "bg-info"
    elsif percentage_complete <= 99
      "bg-success"
    elsif percentage_complete >= 100
      "bg-primary"
    end
  end

  def success_state_badge_color(boolean)
    boolean ? "bg-success" : "bg-danger"
  end

  def working_status(working)
    working.active? ? content_tag(:span, "A", class: "badge bg-primary") : content_tag(:span, "S", class: "badge bg-secondary")
  end
end
