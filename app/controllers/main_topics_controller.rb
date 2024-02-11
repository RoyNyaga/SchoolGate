class MainTopicsController < ApplicationController
  before_action :set_main_topic, only: %i[ show edit update destroy ]

  # GET /main_topics or /main_topics.json
  def index
    @main_topics = MainTopic.all
  end

  # GET /main_topics/1 or /main_topics/1.json
  def show
  end

  # GET /main_topics/new
  def new
    @main_topic = MainTopic.new
  end

  # GET /main_topics/1/edit
  def edit
  end

  # POST /main_topics or /main_topics.json
  def create
    @main_topic = MainTopic.new(main_topic_params)

    respond_to do |format|
      if @main_topic.save
        format.html { redirect_to main_topic_url(@main_topic), notice: "Main topic was successfully created." }
        format.json { render :show, status: :created, location: @main_topic }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @main_topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /main_topics/1 or /main_topics/1.json
  def update
    respond_to do |format|
      if @main_topic.update(main_topic_params)
        format.html { redirect_to main_topic_url(@main_topic), notice: "Main topic was successfully updated." }
        format.json { render :show, status: :ok, location: @main_topic }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @main_topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /main_topics/1 or /main_topics/1.json
  def destroy
    @main_topic.destroy!

    respond_to do |format|
      format.html { redirect_to main_topics_url, notice: "Main topic was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_main_topic
      @main_topic = MainTopic.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def main_topic_params
      params.require(:main_topic).permit(:teacher_id, :curriculum_id, :title, :is_complete)
    end
end
