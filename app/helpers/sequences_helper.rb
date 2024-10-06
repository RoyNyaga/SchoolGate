module SequencesHelper
  def generate_student_marks_input(form, sequence, student)
    if sequence.persisted?
      form.number_field :mark, name: "sequence[marks][][mark]", step: "any", class: "sequence-mark-input", value: student.sequence_mark_per_subject(sequence.hashed_marks)
    else
      form.number_field :mark, name: "sequence[marks][][mark]", step: "any", class: "sequence-mark-input"
    end
  end

  def generate_student_competence_based_marks(form, sequence, student, competence)
    if sequence.persisted?
    else
      form.number_field :mark, name: "sequence[marks][][mark][][competence_mark]", class: "sequence-mark-input"
    end
  end

  def generate_is_enrolled_input(form, sequence, student)
    options = [["Yes", true], ["No", false]]
    if sequence.persisted?
      mark_object = student.get_mark_object(sequence.hashed_marks)
      is_enrolled = mark_object.present? ? mark_object["is_enrolled"] : false
      selected_option = is_enrolled ? options.first : options.last
      options.delete_if { |item| item == selected_option } # remove selected_option from options
      selected_option[2] = { selected: true } # update selected_option to include { selected: true } in it's array
      options << selected_option # add the updated selected_options back to options
      form.select :marks, options, {}, { name: "sequence[marks][][is_enrolled]" }
    else
      form.select :marks, [["Yes", true, { selected: true }], ["No", false]], {}, { name: "sequence[marks][][is_enrolled]" }
    end
  end

  def status_badge_color(sequence)
    if sequence.status == "in_progress"
      "bg-secondary"
    elsif sequence.status == "submitted"
      "bg-warning"
    elsif sequence.status == "rejected"
      "bg-danger"
    elsif sequence.status == "approved"
      "bg-success"
    end
  end

  def generate_student_assessment_mark_input(form, assessment, student, marks)
    if assessment.persisted?
      form.number_field :mark, name: "assessment[marks][][mark]", step: "any", class: "sequence-mark-input", value: student.assessment_mark_per_subject(marks)
    else
      form.number_field :mark, name: "assessment[marks][][mark]", step: "any", class: "sequence-mark-input"
    end
  end

  def generate_is_present_input(form, sequence, student, marks)
    options = [["Yes", true], ["No", false]]
    if sequence.persisted?
      mark_object = student.get_mark_object(marks)
      is_present = mark_object.present? ? mark_object["is_present"] : false
      selected_option = is_present ? options.first : options.last
      options.delete_if { |item| item == selected_option } # remove selected_option from options
      selected_option[2] = { selected: true } # update selected_option to include { selected: true } in it's array
      options << selected_option # add the updated selected_options back to options
      form.select :marks, options, {}, { name: "assessment[marks][][is_present]" }
    else
      form.select :marks, [["Yes", true, { selected: true }], ["No", false]], {}, { name: "assessment[marks][][is_present]" }
    end
  end
end
