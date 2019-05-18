class Api::V1::User::BaseUserController < Api::V1::BaseApiController
  before_action :authenticate_user

  def current_user
    @current_user ||= User.find_by(authentication_token: request.headers['X-User-Token'])
  end

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  private

  def authenticate_user
    return if current_user
    render json: { error: 'unauthorized access, please re-login' }, status: :unauthorized
  end
end
