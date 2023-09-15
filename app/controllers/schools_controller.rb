class SchoolsController < ApplicationController
  before_action :set_school, only: [:show, :update, :edit, :destroy]

  def index
    authorize School
    @schools = School.all
  end

  def new
    @school = School.new
    authorize @school
  end

  def show
    authorize @school
  end

  def edit
    authorize @school
  end

  def home
    @school = current_user.school
  end

  def home_edit
    @school = current_user.school
    authorize @school
  end

  def create
    @school = School.new(school_params)
    authorize @school

    respond_to do |format|
      if @school.save
        format.html { redirect_to school_url(@school), notice: "School was successfully created." }
        format.json { render :show, status: :created, location: @school }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @school.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @school.update(school_params)
        url = current_user.admin? ? school_path(@school) : home_path
        format.html { redirect_to url, notice: "School was successfully updated." }
        format.json { render :show, status: :ok, location: @school }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @school.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @school
    @school.destroy

    respond_to do |format|
      format.html { redirect_to schools_url, notice: "School was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_school
    @school = School.find(params[:id])
  end

  def school_params
    params.require(:school).permit(:name, :description)
  end
end
