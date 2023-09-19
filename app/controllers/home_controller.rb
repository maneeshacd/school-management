class HomeController < ApplicationController
  def show
    redirect_to current_user.admin? ? schools_path : home_path
  end
end
