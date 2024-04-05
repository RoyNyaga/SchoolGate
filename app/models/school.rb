class School < ApplicationRecord
  belongs_to :teacher
  has_many :school_classes, dependent: :destroy
  has_many :students, dependent: :destroy
  has_many :subjects, dependent: :destroy
  has_many :workings, dependent: :destroy
  has_many :workers, through: :workings, dependent: :destroy, source: "teacher"
  has_many :invitations, dependent: :destroy
  has_many :sequences, dependent: :destroy
  has_many :terms, dependent: :destroy
  has_many :report_cards, dependent: :destroy
  has_many :fees, dependent: :destroy
  has_many :progresses, dependent: :destroy
  has_many :academic_years
  has_many :report_card_generators
  has_many :faculties

  store_accessor :school_fees_settings, :level_1_fees, :level_2_fees, :level_3_fees, :level_4_fees,
                 :level_5_fees, :level_6_fees, :level_7_fees

  store_accessor :student_id_settings, :school_identifier

  enum education_level: { basic_education: 1, secondary_education: 2, higher_education: 3 }

  scope :without_settings_attr, -> {
      select(:full_name, :id, :teacher_id, :abbreviation, :town,
             :address, :moto)
    }
end
