class StudentsController < ApplicationController
  include ApplicationHelper # this is to enable us access the generate_modal_id helper method from this controller
  layout "school_layout"
  before_action :check_for_current_school
  before_action :set_student, only: %i[ show edit update destroy update_photo ]

  # GET /students or /students.json
  def index
    @students = Student.all
  end

  # GET /students/1 or /students/1.json
  def show
    @report_cards = @student.report_cards.includes(:term, :school_class)
  end

  # GET /students/new
  def new
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
  end

  # POST /students or /students.json
  def create
    @student = Student.new(student_params)

    respond_to do |format|
      if @student.save
        format.html { redirect_to student_url(@student), notice: "Student was successfully created." }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1 or /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to student_url(@student), notice: "Student was successfully updated." }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_photo
    if @student.update(photo_params)
      render json: { image_url: url_for(@student.photo),
                     modal_id: generate_modal_id("photo_form", record: @student),
                     message: "Successfully Updated Photo", success: true }, status: :ok
    else
      render json: { message: @student.errors.full_messages, success: false }, status: :unprocessable_entity
    end
  end

  # DELETE /students/1 or /students/1.json
  def destroy
    @student.destroy!

    respond_to do |format|
      format.html { redirect_to students_url, notice: "Student was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def json_search
    @subject = Subject.find(params[:subject_id])
    @students = Student.where("lower(students.full_name) like '%#{params[:student_name].downcase}%' AND school_class_id = #{@subject.school_class_id}")
    render json: @students.select(:id, :full_name)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_student
    @student = Student.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def student_params
    params.require(:student).permit(:school_id, :school_class_id, :fathers_name, :fathers_contact,
                                    :mothers_name, :mothers_contact, :guidance_name, :guidance_contact, :date_of_birth, :address, :subjects,
                                    :town, :first_name, :last_name)
  end

  def photo_params
    params.require(:student).permit(:photo)
  end
end
