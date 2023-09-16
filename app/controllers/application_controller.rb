class ApplicationController < ActionController::Base
  # prepend SetUserByToken

  include Pundit::Authorization
  impersonates :user
  protect_from_forgery unless: -> { request.format.json? }
  before_action :custom_authenticate_user!
  # before_action :authenticate_user!

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    if request.format.json?
      render json: { message: flash[:alert] }, status: :forbidden
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def not_found
    if request.format.json?
      render json: { message: "Couldn't find resource" }, status: :not_found
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def custom_authenticate_user!
    if request.format.json?
      # For JSON API requests, use Devise's authenticate_api_user!
      authenticate_api_user!
    else
      # For HTML requests, use Devise's authenticate_user!
      authenticate_user!
    end
  end
end
