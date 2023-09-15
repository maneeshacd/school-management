class SchoolAdminsController < ApplicationController
  before_action :set_school, except: [:impersonate, :stop_impersonating]
  before_action :set_school_admin, only: [:destroy, :show, :edit, :update]

  def index
    @school_admins = @school.admins
  end

  def new
    @school_admin = User.new
  end

  def edit; end

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

  def create
    @school_admin = @school.admins.build(school_admin_params)

    respond_to do |format|
      if @school_admin.save
        format.html { redirect_to school_school_admin_url(@school, @school_admin), notice: "School admin was successfully created." }
        format.json { render :show, status: :created, location: @school_admin }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @school_admin.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      updated = if school_admin_params[:password].present?
        @school_admin.update(school_admin_params)
      else
        @school_admin.update_without_password(school_admin_params)
      end

      if updated
        format.html { redirect_to school_school_admin_path(@school, @school_admin), notice: "School admin was successfully updated." }
        format.json { render :show, status: :ok, location: @school_admin }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @school_admin.errors, status: :unprocessable_entity }
      end
    end
  end

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
    params.require(:school_admin).permit(:name, :email, :password, :password_confirmation, :description)
  end
end
