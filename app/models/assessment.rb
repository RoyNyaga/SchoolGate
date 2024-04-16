class Assessment < ApplicationRecord
  belongs_to :school
  belongs_to :academic_year
  belongs_to :course
  belongs_to :semester

  enum assessment_type: { ca: 1, exam: 2, resit: 3 }

  def hashed_marks
    # parsing marks to ruby hash and converting the mark value to float
    self.marks.map { |m| eval(m) }.map { |a|
      { "id" => a["id"], "full_name" => a["full_name"], "mark" => a[
        "mark"].to_f, "is_present" => string_to_boolean(a["is_present"]) }
    }
  end
end
