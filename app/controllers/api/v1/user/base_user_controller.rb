class Api::V1::User::BaseUserController < Api::V1::BaseApiController
  before_action :authenticate_user

  def current_user
    @current_login ||= Login.find_by(token: request.headers['X-User-Token'])
    @current_user = @current_login&.user
  end

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  private

  def authenticate_user
    JWT.decode(request.headers['X-User-Token'], hmac_secret, true, { algorithm: 'HS256' }) if current_user
    return if current_user
    render json: { message: 'unauthorized access, please re-login' }, status: :unauthorized
  end
end
