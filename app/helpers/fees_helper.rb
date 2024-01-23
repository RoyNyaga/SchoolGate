module FeesHelper
  def generate_progress_bar(percentage_complete)
    content_tag(:div, "#{percentage_complete} %", class: "progress-bar #{generate_progress_background(percentage_complete)} text-dark fee-progress-fonts",
                                                  role: "progressbar", "aria-label": "Example with label", style: "width: #{percentage_complete}%", "aria-valuenow": percentage_complete, "aria-valuemin": 0, "aria-valuemax": 100)
  end

  def generate_progress_background(percentage_complete)
    if percentage_complete <= 25
      "bg-danger"
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

  def total_fee_paid_span(percentage_complete, total_feed_paid)
    content_tag(:span, total_feed_paid, class: "badge #{generate_progress_background(percentage_complete)}")
  end

  def generate_installment_input_field(form, value)
    form.number_field :installments, name: "fee[installments][]", value: value, class: "general-input-styles", data: { action: "fees#calculateSum" }
  end

  def generate_student_marks_input(form, sequence, student)
    if sequence.persisted?
      form.number_field :mark, name: "sequence[marks][][mark]", step: "any", value: student.sequence_mark_per_subject(sequence.hashed_marks)
    else
      form.number_field :mark, name: "sequence[marks][][mark]", step: "any"
    end
  end
end
