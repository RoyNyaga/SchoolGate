module SubjectsHelper
  def generate_competence_input_field(form, value)
    form.text_field :installments, name: "subject[competences][]", value: value,
                                   class: "general-input-styles", placeholder: "enter a competence"
  end
end
