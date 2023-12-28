class ReportCard < ApplicationRecord
  belongs_to :school
  belongs_to :school_class
  belongs_to :term
end
