class HomeController < ApplicationController
  def show
    if current_user.admin?
      redirect_to schools_path
    else
      redirect_to home_path
    end
  end
end
