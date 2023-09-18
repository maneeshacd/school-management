class BatchesController < ApplicationController
  before_action :set_course
  before_action :set_batch, only: %i[ show edit update destroy ]

  # @url [GET] /courses/:course_id/batches.json
  #
  # @param course_id [Integer] Course ID of the btach.
  # @param [Hash] Optional query parameters.
  # @option options [Integer] :page The page number.
  # @option options [Integer] :per_page The number of items per page.
  #
  # @return [Array<Item>] An array of batches.
  def index
    @batches = @course.batches.paginate(page: params[:page], per_page: params[:per_page])
  end

  # @url [GET] /courses/:course_id/batches/:id.json
  #
  # @param id [Integer] id (required) The ID of the batch.
  # @param course_id [Integer] Course ID of the btach.
  # @return [Batch] The course resource.
  def show
    @already_enrolled = current_user.student_batches.include?(@batch)
  end

  def new
    authorize Batch
    @batch = @course.batches.build
  end

  def edit
    authorize @batch
  end

  # @url [POST] /courses/:course_id/batches.json
  #
  # @param course_id [Integer] Course ID of the btach.
  # @param name [String] (Required) Name of the batch.
  # @param description [Text] (Required) Description of the batch.
  # @param start_date [Date] (Required) Start date of the batch.
  # @param end_date [Date] (Required) End date of the batch.
  # @return [Batch] The batch resource.
  def create
    authorize Batch
    @batch = @course.batches.build(batch_params)

    respond_to do |format|
      if @batch.save
        format.html { redirect_to course_batch_url(@course, @batch), notice: "Batch was successfully created." }
        format.json { render :show, status: :created, location: @batch }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @batch.errors, status: :unprocessable_entity }
      end
    end
  end

  # @url [PATCH] /courses/:course_id/batches/:id.json
  #
  # @param id [Integer] id (required) The ID of the batch.
  # @param course_id [Integer] Course ID of the btach.
  # @param name [Integer] Name of the batch.
  # @param description [Text] Description of the batch.
  # @return [Batch] The batch resource.
  def update
    authorize @batch
    respond_to do |format|
      if @batch.update(batch_params)
        format.html { redirect_to course_batch_url(@course, @batch), notice: "Batch was successfully updated." }
        format.json { render :show, status: :ok, location: @batch }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @batch.errors, status: :unprocessable_entity }
      end
    end
  end

  # @url [DELETE] /courses/:course_id/batches/:id.json
  #
  # @param id [Integer] id (required) The ID of the batch.
  # @param course_id [Integer] Course ID of the btach.
  # @return No content
  def destroy
    authorize @batch
    @batch.destroy

    respond_to do |format|
      format.html { redirect_to course_batches_url(@course), notice: "Batch was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def set_batch
      @batch = Batch.find(params[:id])
    end

    def set_course
      @course = Course.find(params[:course_id])
    end

  def batch_params
    params.require(:batch).permit(:name, :description, :start_date, :end_date)
  end
end
