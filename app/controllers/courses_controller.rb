class CoursesController < ApplicationController
  before_action :set_course, only: %i[ show edit update destroy ]

  def index
    @courses = current_user.school.courses
  end

  def show; end

  def new
    @course = Course.new
  end

  def edit; end

  def create
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

  def update
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

  def destroy
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
