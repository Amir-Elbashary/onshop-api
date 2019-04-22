class Api::V1::Merchant::BaseMerchantController < Api::V1::BaseApiController
  before_action :authenticate_merchant

  def current_merchant
    @current_merchant ||= Merchant.find_by(authentication_token: request.headers['X-User-Token'])
  end

  private

  def authenticate_merchant
    return if current_merchant
    render json: { error: 'unauthorized access, please re-login' }, status: :unauthorized
  end
end
