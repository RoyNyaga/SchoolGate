require "test_helper"

class StudentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @student = students(:one)
  end

  test "should get index" do
    get students_url
    assert_response :success
  end

  test "should get new" do
    get new_student_url
    assert_response :success
  end

  test "should create student" do
    assert_difference("Student.count") do
      post students_url, params: { student: { address: @student.address, date_of_birth: @student.date_of_birth, fathers_contact: @student.fathers_contact, fathers_name: @student.fathers_name, full_name: @student.full_name, guidance_contact: @student.guidance_contact, guidance_name: @student.guidance_name, mothers_contact: @student.mothers_contact, mothers_name: @student.mothers_name, school_class_id: @student.school_class_id, school_id: @student.school_id, subjects: @student.subjects } }
    end

    assert_redirected_to student_url(Student.last)
  end

  test "should show student" do
    get student_url(@student)
    assert_response :success
  end

  test "should get edit" do
    get edit_student_url(@student)
    assert_response :success
  end

  test "should update student" do
    patch student_url(@student), params: { student: { address: @student.address, date_of_birth: @student.date_of_birth, fathers_contact: @student.fathers_contact, fathers_name: @student.fathers_name, full_name: @student.full_name, guidance_contact: @student.guidance_contact, guidance_name: @student.guidance_name, mothers_contact: @student.mothers_contact, mothers_name: @student.mothers_name, school_class_id: @student.school_class_id, school_id: @student.school_id, subjects: @student.subjects } }
    assert_redirected_to student_url(@student)
  end

  test "should destroy student" do
    assert_difference("Student.count", -1) do
      delete student_url(@student)
    end

    assert_redirected_to students_url
  end
end
