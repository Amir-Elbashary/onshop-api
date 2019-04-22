class Api::V1::Merchant::MerchantsController < Api::V1::Merchant::BaseMerchantController

  swagger_controller :merchants, 'Merchant'

  swagger_api :update do
    summary 'Updating merchant info'
    notes "Update merchant profile info"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Merchant Authentication Token'
    param :form, 'merchant[first_name]', :string, :required, 'Merchant first name'
    param :form, 'merchant[last_name]', :string, :required, 'Merchant last name'
    response :ok
    response :unauthorized
    response :unprocessable_entity
  end

  def update
    if @current_merchant.update(merchant_params)
      render json: { message: 'merchant has been updated', merchant: @current_merchant }, status: :ok
    else
      render json: @current_merchant.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def merchant_params
    params.require(:merchant).permit(:email, :password, :password_confirmation, :first_name, :last_name)
  end
end
