class Api::V1::Admin::BaseAdminController < Api::V1::BaseApiController
  before_action :authenticate_admin

  def current_admin
    @current_login ||= Login.find_by(token: request.headers['X-User-Token'])
    @current_admin = @current_login&.admin
  end

  def current_ability          
    @current_ability ||= Ability.new(current_admin)
  end 

  private

  def authenticate_admin
    JWT.decode(request.headers['X-User-Token'], hmac_secret, true, { algorithm: 'HS256' }) if current_admin
    return if current_admin
    render json: { message: 'unauthorized access, please re-login' }, status: :unauthorized
  end
end
