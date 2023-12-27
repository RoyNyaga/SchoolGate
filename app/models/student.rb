class Student < ApplicationRecord
  belongs_to :school
  belongs_to :school_class

  def sequence_mark_per_subject(arr)
    arr.find { |student| student["id"] == id.to_s }
  end
end
