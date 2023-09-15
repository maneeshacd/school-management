class EnrollmentsController < ApplicationController
  before_action :set_batch, except: :student_index
  before_action :set_enrollment, only: %i[ show edit update destroy ]

  # GET /enrollments or /enrollments.json
  def index
    authorize Enrollment
    @enrollments = @batch.enrollments.includes(:batch, :student)
  end

  def student_index
    authorize Enrollment
    @enrollments = current_user.student_enrollments
  end

  # GET /enrollments/1 or /enrollments/1.json
  def show; end

  # POST /enrollments or /enrollments.json
  def create
    authorize Enrollment
    already_enrolled_to_course? and return
    @enrollment = current_user.student_enrollments.build(batch: @batch)

    respond_to do |format|
      if @enrollment.save
        format.html { redirect_to enrollments_path, notice: "Enrollment was successfully created." }
        format.json { render :show, status: :created, enrollment: @enrollment }
      else
        format.html {
          redirect_to course_batch_path(@batch.course, @batch),
          alert: @enrollment.errors.full_messages.to_sentence
        }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /enrollments/1 or /enrollments/1.json
  def update
    authorize @enrollment
    @enrollment.status = params[:status]
    respond_to do |format|
      if @enrollment.save
        format.html { redirect_to batch_enrollments_url(@batch), notice: "Enrollment was successfully updated." }
        format.json { render :show, status: :ok, enrollment: @enrollment }
      else
        format.html { render :index, status: :unprocessable_entity, notice: 'Not updated' }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /enrollments/1 or /enrollments/1.json
  def destroy
    authorize @enrollment
    respond_to do |format|
      if @enrollment.destroy
        format.html { redirect_to root_path, notice: "Enrollment was successfully destroyed." }
        format.json { head :no_content }
      else
        format.html { render :show, status: :unprocessable_entity }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def already_enrolled_to_course?
      if current_user.enrolled_courses.include?(@batch.course)
        redirect_to(
          course_batch_path(@batch.course, @batch),
          alert: 'You already enrolled to another batch of this same course'
        ) and return true
      end
    end

    def set_batch
      @batch = Batch.find(params[:batch_id])
    end

    def set_enrollment
      @enrollment = Enrollment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def enrollment_params
      params.require(:enrollment).permit(:batch_id, :status)
    end
end
