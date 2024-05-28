class QuestionnairesController < ApplicationController
  skip_before_action :authenticate_teacher!
  before_action :create_teacher, only: [:create_teacher]

  def new_teacher_questionnaire
    @questionnaire = TeacherQue.new
  end

  def create_teacher
    @questionnaire = TeacherQue.new(teacher_questionnaire_params)
    if @questionnaire.save
      flash[:success] = "Questionnaire submitted"
      redirect_to thanks_questionnaires_path
    else
      flash[:error] = "There were some errors in the form"
      render :new_teacher_questionnaire
    end
  end

  def new_proprietor_questionnaire
    @questionnaire = ProprietorQue.new
  end

  def create_proprietor
    @questionnaire = ProprietorQue.new(proprietor_questionnaire_params)
    if @questionnaire.save
      flash[:success] = "Questionnaire submitted"
      redirect_to thanks_questionnaires_path
    else
      flash[:success] = "There were some errors in the form"
      render :new_proprietor_questionnaire
    end
  end

  def index
  end

  def thanks
  end

  private

  def teacher_questionnaire_params
    params.require(:teacher_que).permit(:full_name, :phone_number, :name_of_schools_taught, :location_of_schools,
                                        :education_level, :progress_importance, :comfort_in_filling_progress, :track_hours_usefulness,
                                        :online_report_cards, :referal_school_name, :referal_location, :referal_proprietors_name,
                                        :referal_proprietors_contact, most_usefull_feature: [])
  end

  def proprietor_questionnaire_params
    params.require(:proprietor_que).permit(:full_name, :phone_number, :name_of_school, :location, :student_profile, :student_performance, :student_attendance, :teachers_performance,
                                           :curriculum_tracking, :time_taught_tracking, :report_card_auto_generation, :school_fees_management,
                                           :electronic_school_fees_receipt, :verifyable_school_fees_receipt, :school_fees_reminder, :teachers_payroll,
                                           :online_admission_form, :additional_features, :should_join_community, :education_level, :should_join_community)
  end
end
