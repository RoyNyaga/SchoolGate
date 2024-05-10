class PagesController < ApplicationController
  skip_before_action :authenticate_teacher!

  def home
  end
end
