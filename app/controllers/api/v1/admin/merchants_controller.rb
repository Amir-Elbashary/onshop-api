class Api::V1::Admin::MerchantsController < Api::V1::Admin::BaseAdminController
  load_and_authorize_resource
  skip_load_resource expect: :index
  before_action :set_merchant, only: :destroy

  swagger_controller :merchants, 'Admin'

  swagger_api :create do
    summary 'Adding new merchant to OnShop'
    notes "Provide the required info to create new merchant"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Admin Authentication Token'
    param :form, 'merchant[email]', :email, :required, 'Merchant Email'
    param :form, 'merchant[password]', :password, :required, 'Merchant password'
    param :form, 'merchant[password_confirmation]', :password, :required, 'Merchant password confirmation'
    param :form, 'merchant[first_name]', :string, :required, 'Merchant first name'
    param :form, 'merchant[last_name]', :string, :required, 'Merchant last name'
    param :form, 'merchant[gender]', :string, :optional, 'Merchant gender'
    param :form, 'merchant[phone_number]', :string, :optional, 'Merchant phone number'
    response :ok
    response :unauthorized
    response :unprocessable_entity
  end

  def create
    if params[:merchant][:gender].present? && !['unspecified', 'male', 'female'].include?(params[:merchant][:gender])
      return render json: { message: 'only unspecified, male and female are allowed as gender, or leave it blank' },
                    status: :unprocessable_entity
    end

    @merchant = Merchant.new(merchant_params)
    if @merchant.save
      render json: { message: 'merchant has been added', merchant: @merchant }, status: :created
    else
      render json: @merchant.errors.full_messages, status: :unprocessable_entity
    end
  end

  swagger_api :index do
    summary 'Listing all merchants'
    notes "This API lists all merchants available on the system"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Admin Authentication Token'
    response :ok
    response :unauthorized
  end

  def index
    return render json: { message: 'no merchants on the system' }, status: :ok unless @merchants.any?
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
    params.require(:merchant).permit(:email, :password, :password_confirmation,
                                     :first_name, :last_name, :gender, :phone_number)
  end

  def set_merchant
    @merchant = Merchant.find(params[:id])
  end
end
