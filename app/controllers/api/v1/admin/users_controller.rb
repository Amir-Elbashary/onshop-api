class Api::V1::Admin::UsersController < Api::V1::Admin::BaseAdminController
  load_and_authorize_resource
  skip_load_resource
  before_action :set_users, only: :index
  before_action :set_user, only: :destroy

  swagger_controller :users, 'Admin'

  swagger_api :create do
    summary 'Adding new user to OnShop'
    notes "Provide the required info to create new user"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Admin Authentication Token'
    param :form, 'user[email]', :email, :required, 'User Email'
    param :form, 'user[password]', :password, :required, 'User password'
    param :form, 'user[password_confirmation]', :password, :required, 'User password confirmation'
    param :form, 'user[first_name]', :string, :required, 'User first name'
    param :form, 'user[last_name]', :string, :required, 'User last name'
    param :form, 'user[shipping_address]', :string, :required, 'User Shipping Address'
    param :form, 'user[gender]', :string, :optional, 'User gender'
    param :form, 'user[country]', :string, :optional, 'User country'
    param :form, 'user[city]', :string, :optional, 'User city'
    param :form, 'user[region]', :string, :optional, 'User region'
    param :form, 'user[phone_number]', :string, :optional, 'User phone number'
    response :ok
    response :unauthorized
    response :unprocessable_entity
  end

  def create
    if params[:user][:gender].present? && !['unspecified', 'male', 'female'].include?(params[:user][:gender])
      return render json: { message: 'only unspecified, male and female are allowed as gender, or leave it blank' },
                    status: :unprocessable_entity
    end

    @user = User.new(user_params)
    if @user.save
      render json: { message: 'user has been added', user: @user }, status: :created
    else
      render json: @user.errors.full_messages, status: :unprocessable_entity
    end
  end

  swagger_api :index do
    summary 'Listing all users'
    notes "This API lists all users available on the system"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Admin Authentication Token'
    param :query, :page, :string, 'Page'
    response :ok
    response :unauthorized
  end

  def index; end

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
    return unless @user.destroy
    render json: { message: 'user was deleted', user: @user }, status: :ok
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation,
                                 :first_name, :last_name, :shipping_address, :gender,
                                 :country, :city, :region, :phone_number)
  end

  def set_users
    @users = User.all.page(params[:page]).per_page(32) 
  end

  def set_user
    @user = User.find(params[:id])
  end
end
