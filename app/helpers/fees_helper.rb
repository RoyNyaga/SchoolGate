module FeesHelper
  def generate_progress_bar(percent_complete)
    content_tag(:div, percent_complete, class: "progress-bar #{generate_progress_background(percent_complete)} text-dark fee-progress-fonts", role: "progressbar", "aria-label": "Example with label", style: "width: #{percent_complete}%", "aria-valuenow": percent_complete, "aria-valuemin": 0, "aria-valuemax": 100)
  end

  def generate_progress_background(percent_complete)
    if percent_complete <= 25
      "bg-danger"
    elsif percent_complete <= 50
      "bg-warning"
    elsif percent_complete <= 75
      "bg-info"
    elsif percent_complete <= 99
      "bg-success"
    elsif percent_complete >= 100
    end
  end
end
