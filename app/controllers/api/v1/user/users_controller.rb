class Api::V1::User::UsersController < Api::V1::User::BaseUserController
  load_and_authorize_resource
  skip_load_resource

  swagger_controller :users, 'User'

  swagger_api :favourite_products do
    summary 'User favourite products'
    notes "Listing user favourite products"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'User Authentication Token'
    param :query, :loc, :string, 'Locale'
    response :ok
    response :unauthorized
  end

  def favourite_products
    @favourite_products = current_user.favourite_products
  end

  private

  def merchant_params
    params.require(:merchant).permit(:email, :password, :password_confirmation, :first_name, :last_name)
  end
end
