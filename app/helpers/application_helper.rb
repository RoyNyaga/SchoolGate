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
end
