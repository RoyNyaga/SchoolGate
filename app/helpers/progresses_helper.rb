module ProgressesHelper
  def topic_progress_select(form, topic)
    options = [["in_progress", "2"], ["completed", "3"]]
    options.each do |option|
      option << { selected: true } if option[0] == topic.progress
    end

    form.select :marks, options, {}, { name: "progress[topics][][progress]", class: "progress-curriculum-select-input" }
  end
end
