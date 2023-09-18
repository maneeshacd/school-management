class ApplicationController < ActionController::Base

  include Pundit::Authorization
  impersonates :user
  protect_from_forgery unless: -> { request.format.json? }
  before_action :authenticate_user!
  protect_from_forgery with: :exception, unless: :json_request?
  protect_from_forgery with: :null_session, if: :json_request?
  skip_before_action :verify_authenticity_token, if: :json_request?
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::InvalidAuthenticityToken,
              with: :invalid_auth_token
  before_action :set_current_user, if: :json_request?


  private

  def json_request?
    request.format.json?
  end
  # Use api_user Devise scope for JSON access
  def authenticate_user!(*args)
    super and return unless args.blank?
    json_request? ? authenticate_api_user! : super
  end

  def invalid_auth_token
    respond_to do |format|
      format.html { redirect_to sign_in_path,
                    error: 'Login invalid or expired' }
      format.json { head 401 }
    end
  end

  def set_current_user
    @current_user ||= warden.authenticate(scope: :api_user)
  end

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

end
