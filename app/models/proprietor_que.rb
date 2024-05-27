class ProprietorQue < ApplicationRecord
  store_accessor :functionality_importance, :student_profile, :student_performance, :student_attendance, :teachers_performance,
                 :curriculum_tracking, :time_taught_tracking, :report_card_auto_generation, :school_fees_management,
                 :electronic_school_fees_receipt, :verifyable_school_fees_receipt, :school_fees_reminder, :teachers_payroll,
                 :online_admission_form

  store_accessor :other_questions, :should_join_community
end
