module SequencesHelper
  def generate_student_marks_input(form, sequence, student)
    if sequence.persisted?
      form.number_field :mark, name: "sequence[marks][][mark]", step: "any", value: student.sequence_mark_per_subject(sequence.hashed_marks)
    else
      form.number_field :mark, name: "sequence[marks][][mark]", step: "any"
    end
  end

  def generate_years
    [Date.today.year + 1, Date.today.year, Date.today.year - 1]
  end
end
