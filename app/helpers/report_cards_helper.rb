module ReportCardsHelper
  def detail_dynamic_inputs(form, input_type, input_name, value, class_names: "inputs")
    # form.number_field :mark, name: "sequence[marks][][mark]", step: "any", class: "sequence-mark-input"

    form.send(input_type, :details, name: input_name, value: value, class: class_names)
  end
end
