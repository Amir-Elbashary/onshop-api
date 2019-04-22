class Api::V1::Admin::MerchantsController < Api::V1::Admin::BaseAdminController
  before_action :set_merchant, only: :destroy

  swagger_controller :merchants, 'Admin'

  swagger_api :create do
    summary 'Adding new merchant to OnShop'
    notes "Provide the required info to create new merchant"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Admin Authentication Token'
    param :form, 'merchant[email]', :email, :required, 'Merchant Email'
    param :form, 'merchant[password]', :password, :required, 'Merchant password'
    param :form, 'merchant[password_confirmation]', :password, :required, 'Merchant password password confirmation'
    param :form, 'merchant[first_name]', :password, :required, 'Merchant first name'
    param :form, 'merchant[last_name]', :password, :required, 'Merchant last name'
    response :ok
    response :unauthorized
    response :unprocessable_entity
  end

  def create
    @merchant = Merchant.new(merchant_params)
    if @merchant.save
      render json: { message: 'merchant has been added', merchant: @merchant }, status: :ok
    else
      render json: @merchant.errors.full_messages, status: :unprocessable_entity
    end
  end

  swagger_api :destroy do
    summary 'Deleting merchant from OnShop'
    notes "WARNING: This will delete the merchant and all his associated items permanently"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Admin Authentication Token'
    param :path, :id, :integer, :required, 'Merchant ID'
    response :ok
    response :unauthorized
    response :not_found
  end

  def destroy
    return unless @merchant.destroy
    render json: { message: 'merchant was deleted', merchant: @merchant }, status: :ok
  end

  private

  def merchant_params
    params.require(:merchant).permit(:email, :password, :password_confirmation, :first_name, :last_name)
  end

  def set_merchant
    @merchant = Merchant.find(params[:id])
  end
end
