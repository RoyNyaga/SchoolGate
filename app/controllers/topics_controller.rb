class TopicsController < ApplicationController
  before_action :set_topic, only: %i[ show edit update destroy ]

  # GET /topics or /topics.json
  def index
    @topics = Topic.all
  end

  # GET /topics/1 or /topics/1.json
  def show
  end

  # GET /topics/new
  def new
    @subject = Subject.find(params[:subject_id])
    @topic = Topic.new
    @main_topic = MainTopic.find(params[:main_topic_id])
  end

  # GET /topics/1/edit
  def edit
  end

  # POST /topics or /topics.json
  def create
    @topic = Topic.new(topic_params)

    respond_to do |format|
      if @topic.save
        # format.html { redirect_to topic_url(@topic), notice: "Topic was successfully created." }
        format.turbo_stream { flash.now[:success] = "Topic was Successfully created" }
      else
        format.html { render :new, status: :unprocessable_entity }
        # format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /topics/1 or /topics/1.json
  def update
    respond_to do |format|
      if @topic.update(topic_params)
        format.html { redirect_to topic_url(@topic), notice: "Topic was successfully updated." }
        # format.json { render :show, status: :ok, location: @topic }
      else
        format.html { render :edit, status: :unprocessable_entity }
        # format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1 or /topics/1.json
  def destroy
    @dom_id = "topic_#{@topic.id}"
    @topic.destroy!

    respond_to do |format|
      format.turbo_stream { flash.now[:success] = "Successfully deleted Tpic" }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_topic
    @topic = Topic.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def topic_params
    params.require(:topic).permit(:teacher_id, :main_topic_id, :title, :subject_id)
  end
end
