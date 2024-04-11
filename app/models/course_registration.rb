class CourseRegistration < ApplicationRecord
  include DataTrans
  belongs_to :school
  belongs_to :student
  belongs_to :academic_year
  belongs_to :semester

  before_save :set_credit_value

  def title
    "#{academic_year.year} - #{semester.semester_type.humanize}"
  end

  private

  def set_credit_value
    self.credit_val = CourseRegistration.string_to_hash_arr(courses).map { |c| c["credit_val"].to_i }.sum
  end
end
