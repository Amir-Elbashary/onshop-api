class Api::V1::User::BaseUserController < Api::V1::BaseApiController
  rescue_from JWT::ExpiredSignature, with: :session_expired
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

  def session_expired
    login ||= Login.find_by(token: request.headers['X-User-Token'])
    login.token = nil
    login.save
    render json: { message: 'session expired, please relogin' }, status: :unauthorized
  end
end
