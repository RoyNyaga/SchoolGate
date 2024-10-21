module StudentsHelper
  def student_status_color_badge(student)
    if student.status == "active"
      "bg-primary"
    elsif sequence.status == "dropout"
      "bg-warning"
    elsif sequence.status == "dismissed"
      "bg-danger"
    end
  end
end
