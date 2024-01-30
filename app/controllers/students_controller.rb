class StudentsController < ApplicationController
  layout "school_layout"
  before_action :check_for_current_school
  before_action :set_student, only: %i[ show edit update destroy update_photo ]

  # GET /students or /students.json
  def index
    @students = Student.all
  end

  # GET /students/1 or /students/1.json
  def show
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
    # # Convert the blob string to an IO object
    # blob_io = StringIO.new(Base64.decode64(params[:student][:photo]))
    # blob_io.class.class_eval { attr_accessor :original_filename, :content_type }
    # blob_io.original_filename = "image.jpg" # Set a default filename
    # blob_io.content_type = "image/jpeg" # Set the content type

    # # Attach the blob to the Active Storage image_file
    # @student.photo.attach(io: blob_io, filename: blob_io.original_filename, content_type: blob_io.content_type)
    # @student.save
    binding.break
    # respond_to do |format|
    #   format.json { render :edit, status: :ok, location: @student }
    # end
  end

  # DELETE /students/1 or /students/1.json
  def destroy
    @student.destroy!

    respond_to do |format|
      format.html { redirect_to students_url, notice: "Student was successfully destroyed." }
      format.json { head :no_content }
    end
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
                                    :town, :first_name, :last_name, :photo)
  end
end
