class SchoolAdminsController < ApplicationController
  before_action :set_school, except: [:impersonate, :stop_impersonating]
  before_action :set_school_admin, only: [:destroy, :show, :edit, :update]

  # @url [GET] /schools/:school_id/school_admins.json
  #
  # @param school_id [Integer] School ID of the school admin.
  # @param [Hash] Optional query parameters.
  # @option options [Integer] :page The page number.
  # @option options [Integer] :per_page The number of items per page.
  #
  # @return [Array<Item>] An array of school admins.
  def index
    @school_admins = @school.school_admins.paginate(page: params[:page], per_page: params[:per_page])
  end

  def new
    @school_admin = User.new
  end

  def edit; end

  # @url [GET] /schools/:school_id/school_admins/:id.json
  #
  # @param id [Integer] id (required) The ID of the school admin.
  # @param school_id [Integer] School ID of the school admin.
  # @return [SchoolAdmin] The school admin resource.
  def show;  end

  def impersonate
    @school_admin = User.find(params[:id])
    impersonate_user(@school_admin)
    redirect_to root_path
  end

  def stop_impersonating
    stop_impersonating_user
    redirect_to root_path
  end

  # @url [POST] /schools/:school_id/school_admins.json
  #
  # @param school_id [Integer] School ID of the school admin.
  # @param name [String] (Required) Name of the school.
  # @param description [Text] (Required) Description of the school.
  # @return [SchoolAdmin] The school admin resource.
  def create
    @school_admin = @school.school_admins.build(school_admin_params)

    respond_to do |format|
      if @school_admin.save
        format.html { redirect_to school_school_admin_url(@school, @school_admin), notice: "School admin was successfully created." }
        format.json { render :show, status: :created, school_admin: @school_admin }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @school_admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # @url [PATCH] /schools/:school_id/school_admins/:id.json
  #
  # @param id [Integer] id (required) The ID of the school admin.
  # @param school_id [Integer] School ID of the school admin.
  # @param name [Integer] Name of the school admin.
  # @param description [Text] Description of the school admin.
  # @return [SchoolAdmin] The school Admin resource.
  def update
    respond_to do |format|
      updated = if school_admin_params[:password].present?
        @school_admin.update(school_admin_params)
      else
        @school_admin.update_without_password(school_admin_params)
      end

      if updated
        format.html { redirect_to school_school_admin_path(@school, @school_admin), notice: "School admin was successfully updated." }
        format.json { render :show, status: :ok, school_admin: @school_admin }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @school_admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # @url [DELETE] /schools/:school_id/school_admins/:id.json
  #
  # @param id [Integer] id (required) The ID of the school admin.
  # @param school_id [Integer] School ID of the school admin.
  # @return No content
  def destroy
    @school_admin.destroy

    respond_to do |format|
      format.html { redirect_to school_school_admins_url(@school), notice: "School admin was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_school
    @school = School.find(params[:school_id])
  end

  def set_school_admin
    @school_admin = User.find(params[:id])
  end

  def school_admin_params
    params.require(:school_admin).permit(:name, :email, :phone_number, :password, :password_confirmation, :description)
  end
end
