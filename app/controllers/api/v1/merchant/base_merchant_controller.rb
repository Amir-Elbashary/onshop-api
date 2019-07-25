class Api::V1::Merchant::BaseMerchantController < Api::V1::BaseApiController
  before_action :authenticate_merchant

  def current_merchant
    @current_login ||= Login.find_by(token: request.headers['X-User-Token'])
    @current_merchant = @current_login&.merchant
  end

  def current_ability          
    @current_ability ||= Ability.new(current_merchant)
  end 

  private

  def authenticate_merchant
    JWT.decode(request.headers['X-User-Token'], hmac_secret, true, { algorithm: 'HS256' }) if current_merchant
    return if current_merchant
    render json: { message: 'unauthorized access, please re-login' }, status: :unauthorized
  end
end
