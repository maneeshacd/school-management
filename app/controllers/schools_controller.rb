class SchoolsController < ApplicationController
  before_action :set_school, only: [:show, :update, :edit, :destroy]

  # @url [GET] /schools.json
  #
  # @param [Hash] Optional query parameters.
  # @option options [Integer] :page The page number.
  # @option options [Integer] :per_page The number of items per page.
  #
  # @return [Array<Item>] An array of schools.
  def index
    authorize School
    @schools = School.paginate(page: params[:page], per_page: params[:per_page])
  end

  def new
    @school = School.new
    authorize @school
  end

  # @url [GET] /schools/:id.json
  #
  # @param [Integer] id (required) The ID of the school.
  # @return [School] The school resource.
  def show
    authorize @school
  end

  def edit
    authorize @school
  end

  # @url [GET] /home.json
  #
  # @param None
  # @return [School] Returns the school of current user (Student/School Admin).
  def home
    @school = current_user.school
  end

  def home_edit
    @school = current_user.school
    authorize @school
  end

  # @url [POST] /schools.json
  #
  # @param [String] (Required) Name of the school.
  # @param [Text] (Required) Description of the school.
  # @return [School] The school resource.
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

  # @url [PATCH] /schools/:id.json
  #
  # @param name [String] name of the school.
  # @param description [Text] Description of the school.
  # @return [School] The school resource.
  def update
    respond_to do |format|
      if @school.update(school_params)
        url = current_user.admin? ? school_path(@school) : home_path
        format.html { redirect_to url, notice: "School was successfully updated." }
        format.json { render :show, status: :ok, school: @school }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @school.errors, status: :unprocessable_entity }
      end
    end
  end

  # @url [DELETE] /schools/:id.json
  #
  # @param [Integer] id (required) The ID of the school.
  # @return No content
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
