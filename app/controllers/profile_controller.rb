class ProfileController < ApplicationController

  # @url [GET] /profile.json
  #
  # @param None.
  # @return [User] The profile details of user.
  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  # @url [PATCH] /update_profile.json
  #
  # @param None
  # @return [User] The user resource.
  def update
    respond_to do |format|
      @user = current_user
      if @user.update(user_params)
        format.html { redirect_to profile_url, notice: "Profile updated successfully." }
        format.json { render :show, status: :ok, profile: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def user_params
    params.require(:profile).permit(:name, :email, :phone_number, :description, :password, :password_confirmation)
  end
end
