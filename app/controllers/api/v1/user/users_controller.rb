class Api::V1::User::UsersController < Api::V1::User::BaseUserController
  load_and_authorize_resource
  skip_load_resource

  swagger_controller :users, 'User'

  swagger_api :update_profile do
    summary 'Adding existing users to update their own profile'
    notes "Provide the ability of updating user's own profile via their panel"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Admin Authentication Token'
    param :form, 'user[first_name]', :string, :required, 'User first name'
    param :form, 'user[last_name]', :string, :required, 'User last name'
    param :form, 'user[shipping_address]', :string, :required, 'User Shipping Address'
    response :ok
    response :unauthorized
    response :unprocessable_entity
  end

  def update_profile
    if current_user.update(user_params)
      render json: { success: true, user: current_user }, status: :ok
    else
      render json: { success: false, error: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  swagger_api :favourite_products do
    summary 'User favourite products'
    notes "Listing user favourite products"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'User Authentication Token'
    param :query, :page, :string, 'Page'
    param :query, :loc, :string, 'Locale'
    response :ok
    response :unauthorized
  end

  def favourite_products
    @favourite_products = current_user.favourite_products.page(params[:page]).per_page(32)
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :shipping_address)
  end
end
