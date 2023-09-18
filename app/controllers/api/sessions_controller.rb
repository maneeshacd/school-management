class Api::SessionsController < Devise::SessionsController
  skip_before_action :verify_signed_out_user
  respond_to :json

  # @url [POST] /api/login.json
  #
  # @option email [String] Email of user.
  #
  # @option password [Integer] :page The page number.
  #
  # @return [User] User details with token.
  def create
    unless request.format == :json
      sign_out
      render status: 406,
               json: { message: "JSON requests only." } and return
    end
    # auth_options should have `scope: :api_user`
    resource = warden.authenticate!(auth_options)
    if resource.blank?
      render status: 401,
               json: { response: "Access denied." } and return
    end
    sign_in(resource_name, resource)
    respond_with resource, location:
      after_sign_in_path_for(resource) do |format|
        format.json { render json:
                        { success: true,
                              jwt: current_token,
                         response: "Authentication successful"
                         }
                     }
    end
  end


  # @url [DELETE] /api/logout.json

  # @return Logged out message

  def destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    render :json => { message: 'Logged out' }
  end

private
  def current_token
    request.env['warden-jwt_auth.token']
  end
end
