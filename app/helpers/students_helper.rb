module StudentsHelper
  def student_status_color_badge(student)
    if student.status == "active"
      "bg-primary"
    elsif student.status == "dropout"
      "bg-warning"
    elsif student.status == "dismissed"
      "bg-danger"
    end
  end
end
