class Api::V1::Admin::BaseAdminController < Api::V1::BaseApiController

  def current_admin
    @current_admin ||= Admin.find_by(authentication_token: request.headers['X-User-Token'])
  end

  private

  def authenticate_user
    return if current_admin
    render json: { error: 'unauthorized access, please re-login' }, status: :unauthorized
  end
end
