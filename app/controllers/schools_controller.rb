class SchoolsController < ApplicationController
  before_action :set_school

  def show; end

  def edit; end

  def update
    respond_to do |format|
      if @school.update(school_params)
        format.html { redirect_to root_url(@school), notice: "Course was successfully updated." }
        format.json { render :show, status: :ok, location: @school }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @school.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_school
    @school = current_user.school
  end

  def school_params
    params.require(:school).permit(:name, :description)
  end
end
