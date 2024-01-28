module ApplicationHelper
  def genModalId(action_name)
    action_name.strip.downcase.gsub(" ", "-")
  end

  def google_map_src
    "https://maps.googleapis.com/maps/api/js?key=#{ENV["GOOGLE_PLACES_API_KEY"]}&loading=async&libraries=places&callback=initAutocomplete"
  end
end
