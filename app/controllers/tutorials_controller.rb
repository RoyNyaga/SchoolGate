class TutorialsController < InheritedResources::Base
  skip_before_action :authenticate_teacher!
  before_action :set_tutorial, only: [:show, :edit, :update]
  before_action :update_page_visits, only: [:show, :index]

  def index
    @tutorials = Tutorial.all.order(priority: :asc)
    @tutorial = @tutorials.first
  end

  def show
    @tutorials = Tutorial.all.order(priority: :asc)
  end

  def new
    @tutorial = Tutorial.new
  end

  def create
    @tutorial = Tutorial.new(tutorial_params)
    if @tutorial.save
      redirect_to @tutorial
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @tutorial.update(tutorial_params)
      redirect_to @tutorial
    else
      render :edit
    end
  end

  private

  def set_tutorial
    @tutorial = Tutorial.friendly.find(params[:id])
  end

  def tutorial_params
    params.require(:tutorial).permit(:youtube_frame, :slug, :title, :priority)
  end
end
