class Api::V1::Admin::BaseAdminController < Api::V1::BaseApiController
  rescue_from ActiveRecord::InvalidForeignKey, with: :has_relations
  before_action :authenticate_admin

  def current_admin
    @current_login ||= Login.find_by(token: request.headers['X-User-Token'])
    @current_admin = @current_login&.admin
  end

  def current_ability          
    @current_ability ||= Ability.new(current_admin)
  end 

  private

  def has_relations
    render json: { error: 'this user is associated with active carts/orders, please delete them first' }, status: :forbidden
  end

  def authenticate_admin
    JWT.decode(request.headers['X-User-Token'], hmac_secret, true, { algorithm: 'HS256' }) if current_admin
    return if current_admin
    render json: { message: 'unauthorized access, please re-login' }, status: :unauthorized
  end
end
