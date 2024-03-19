module ReportCardGeneratorsHelper
  def generate_error_and_warning_links(failed_error)
    if failed_error["class_name"] == "Sequence"
      link_to failed_error["title"], sequence_path(failed_error["id"].to_i), class: "grey-link-text"
    elsif failed_error["class_name"] == "Subject"
      link_to failed_error["title"], subject_path(failed_error["id"]), class: "grey-link-text"
    end
  end
end
