class PagesController < ApplicationController
  skip_before_action :authenticate_teacher!

  def home
  end

  def teacher_questionnaire
  end

  def contact
  end

  def create_message
    @message = Message.new(message_params)

    if @message.save
      flash[:success] = "Thanks for contacting us, we will get back to you as soon as we can."
      redirect_to :root_path
    else
      flash[:error] = "You message Could not be sent, please fill in the required fields."
      render :contact, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:email, :phone_number, :phone_number_code, :country, :message)
  end
end
