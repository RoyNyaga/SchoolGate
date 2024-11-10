module FeesHelper
  def generate_progress_bar(percentage_complete)
    content_tag(:div, "#{percentage_complete} %", class: "progress-bar #{percentage_badge_color(percentage_complete)} text-dark fee-progress-fonts",
                                                  role: "progressbar", "aria-label": "Example with label", style: "width: #{percentage_complete}%", "aria-valuenow": percentage_complete, "aria-valuemin": 0, "aria-valuemax": 100)
  end

  def total_fee_paid_span(percentage_complete, total_feed_paid)
    content_tag(:span, total_feed_paid, class: "badge #{percentage_badge_color(percentage_complete)}")
  end

  def generate_installment_input_field(form, value)
    form.number_field :installments, name: "fee[installments][]", value: value, class: "general-input-styles", data: { action: "fees#calculateSum" }
  end

  def confliting_fee_color_badge(fee)
    if fee.is_receipt_and_fee_amount_in_phase
      "bg-primary"
    else
      "bg-danger"
    end
  end
end
