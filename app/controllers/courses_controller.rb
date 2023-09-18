class CoursesController < ApplicationController
  before_action :set_course, only: %i[ show edit update destroy ]

  # @url [GET] /courses.json
  #
  # @param [Hash] Optional query parameters.
  # @option options [Integer] :page The page number.
  # @option options [Integer] :per_page The number of items per page.
  #
  # @return [Array<Item>] An array of courses.
  def index
    authorize Course
    @courses = current_user.school.courses.paginate(page: params[:page], per_page: params[:per_page])
  end

  # @url [GET] /courses/:id.json
  #
  # @param [Integer] id (required) The ID of the course.
  # @return [Course] The course resource.
  def show; end

  def new
    authorize Course
    @course = Course.new
  end

  def edit
    authorize @course
  end

  # @url [POST] /courses.json
  #
  # @param name [String] (Required) Name of the course.
  # @param Description [Text] (Required) Description of the Course.
  # @param Years [Integer] (Required) Duration of the Course.
  # @return [Course] The course resource.
  def create
    authorize Course
    @course = Course.new(course_params.merge(school: current_user.school))

    respond_to do |format|
      if @course.save
        format.html { redirect_to course_url(@course), notice: "Course was successfully created." }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end


  # @url [PATCH] /course/:id.json
  #
  # @param name [String] name of the course.
  # @param description [Text] Description of the course.
  # @param Years [Integer] (Required) Duration of the Course.
  # @return [Cousre] The course resource.
  def update
    authorize @course
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to course_url(@course), notice: "Course was successfully updated." }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # @url [DELETE] /course/:id.json
  #
  # @param [Integer] id (required) The ID of the course.
  # @return No content
  def destroy
    authorize @course
    @course.destroy

    respond_to do |format|
      format.html { redirect_to courses_url, notice: "Course was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def set_course
      @course = Course.find(params[:id])
    end

  def course_params
    params.require(:course).permit(:name, :description, :years)
  end
end
