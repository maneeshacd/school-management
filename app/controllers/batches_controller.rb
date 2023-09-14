class BatchesController < ApplicationController
  before_action :set_course
  before_action :set_batch, only: %i[ show edit update destroy ]

  def index
    @batches = @course.batches
  end

  def show; end

  def new
    @batch = @course.batches.build
  end

  def edit; end

  def create
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

  def update
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

  def destroy
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
