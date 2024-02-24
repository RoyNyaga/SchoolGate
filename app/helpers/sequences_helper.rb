module SequencesHelper
  def generate_student_marks_input(form, sequence, student)
    if sequence.persisted?
      form.number_field :mark, name: "sequence[marks][][mark]", step: "any", value: student.sequence_mark_per_subject(sequence.hashed_marks)
    else
      form.number_field :mark, name: "sequence[marks][][mark]", step: "any"
    end
  end

  def generate_is_enrolled_input(form, sequence, student)
    mark_object = student.get_mark_object(sequence.hashed_marks)
    is_enrolled = mark_object.present? ? mark_object["is_enrolled"] : false
    options = [["Yes", true], ["No", false]]
    selected_option = is_enrolled ? options.first : options.last
    options.delete_if { |item| item == selected_option } # remove selected_option from options
    selected_option[2] = { selected: true } # update selected_option to include { selected: true } in it's array
    options << selected_option # add the updated selected_options back to options
    form.select :marks, options, {}, { name: "sequence[marks][][is_enrolled]" }
  end

  def generate_years
    [Date.today.year + 1, Date.today.year, Date.today.year - 1]
  end
end
