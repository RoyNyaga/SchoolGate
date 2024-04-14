class CourseRegistration < ApplicationRecord
  include DataTrans
  belongs_to :school
  belongs_to :student
  belongs_to :academic_year
  belongs_to :semester
  has_many :enrollments

  before_save :set_credit_value
  after_save :create_enrollments

  def title
    "#{academic_year.year} - #{semester.semester_type.humanize}"
  end

  def parse_enrollments
    current_year_id = school.active_academmic_year.id
    CourseRegistration.string_to_hash_arr(courses).map do |course|
      { school_id: school_id, student_id: student_id, course_id: course["id"].to_i,
        academic_year_id: current_year_id, semester_id: semester_id, course_registration_id: id }
    end
  end

  private

  def create_enrollments
    enrollments.destroy_all
    Enrollment.insert_all parse_enrollments
  end

  def set_credit_value
    self.credit_val = CourseRegistration.string_to_hash_arr(courses).map { |c| c["credit_val"].to_i }.sum
  end
end
