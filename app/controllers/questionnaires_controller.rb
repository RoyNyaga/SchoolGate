class QuestionnairesController < ApplicationController
  skip_before_action :authenticate_teacher!
  before_action :create_teacher, only: [:create_teacher]

  def new_teacher_questionnaire
    @questionnaire = TeacherQue.new
  end

  def create_teacher
    @questionnaire = TeacherQue.new(teacher_questionnaire_params)
  end

  def new_proprietor_questionnaire
    @questionnaire = ProprietorQue.new
  end

  def create_proprietor
  end

  private

  def teacher_questionnaire_params
    params.require(:teacher_que).permit(:full_name, :phone_number, :name_of_schools_taught, :location_of_schools,
                                        :education_level, :progress_importance, :comfort_in_filling_progress, :track_hours_usefulness,
                                        :online_report_cards, :referal_school_name, :referal_location, :referal_proprietors_name,
                                        :referal_proprietors_contact, most_usefull_feature: [])
  end
end
