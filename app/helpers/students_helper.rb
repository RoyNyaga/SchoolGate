module StudentsHelper
  def student_photo_action_name(student)
    student.photo.attached? ? "Change Photo" : "Upload Photo"
  end
end
