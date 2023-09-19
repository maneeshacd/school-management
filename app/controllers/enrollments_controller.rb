class EnrollmentsController < ApplicationController
  before_action :set_batch, except: %i[student_index pending]
  before_action :set_enrollment, only: %i[ show edit update destroy ]

  # @url [GET] /batches/:batch_id/enrollments.json
  #
  # @option batch_id [Integer] batch id of enrollments.
  # @option options [Integer] :page The page number.
  # @option options [Integer] :per_page The number of items per page.
  #
  # @return [Array<Item>] An array of schools.
  def index
    authorize Enrollment
    @enrollments = @batch.enrollments.includes(:batch, :student)
  end

  def student_index
    authorize Enrollment
    @enrollments = current_user.student_enrollments
  end

  # @url [GET] /batches/:batch_id/enrollments/:id.json
  #
  # @param id [Integer] id (required) The ID of the enrollment.
  # @param batch_id [Integer] id (required) The batch_id of the enrollment batch.
  # @return [Enrollment] The Enrollment resource.
  def show; end

  # @url [POST] /batches/:batch_id/enrollments.json
  #
  # @param batch_id [Integer] (Required) batch id of enrollment
  # @return [Enrollment] The enrollment resource.
  def create
    authorize Enrollment
    already_enrolled_to_course? and return
    @enrollment = current_user.student_enrollments.build(batch: @batch, school: current_user.school)

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

  # @url [PATCH] /batches/:batch_id/enrollments/:id.json
  #
  # @param batch_id [Integer] (Required) batch id of enrollment
  # @param id [Integer] (Required) id of enrollment
  # @param status [Integer] status of the enrollment (pending / approved / rejected)
  # @return [Enrollment] The enrollment resource.
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

  # @url [DELETE] /batches/:batch_id/enrollments/:id.json
  #
  # @param batch_id [Integer]  The batch ID of the enrollment.
  # @return No content
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

  def pending
    @pending_enrollments = current_user.school.enrollments.includes(:batch, :student)
  end

  private

    def already_enrolled_to_course?
      if current_user.enrolled_courses.include?(@batch.course)
        respond_to do |format|
          format.html {
            redirect_to(
              course_batch_path(@batch.course, @batch),
              alert: 'You already enrolled to another batch of this same course'
            )
          }
          format.json {
            render json: 'You already enrolled to another batch of this same course',
            status: :unprocessable_entity
          }
        end and return true
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
