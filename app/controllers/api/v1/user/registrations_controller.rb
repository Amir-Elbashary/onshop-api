class Api::V1::User::RegistrationsController < Api::V1::User::BaseUserController
  skip_authorization_check
  skip_before_action :authenticate_user

  swagger_controller :registrations, 'User'

  swagger_api :create do
    summary 'Registering new user to OnShop'
    notes "Provide the required info to register a new user"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :form, 'user[email]', :email, :required, 'User Email'
    param :form, 'user[password]', :password, :required, 'User password'
    param :form, 'user[password_confirmation]', :password, :required, 'User password confirmation'
    param :form, 'user[first_name]', :string, :required, 'User first name'
    param :form, 'user[last_name]', :string, :required, 'User last name'
    response :ok
    response :unauthorized
    response :unprocessable_entity
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: { success: true, user: @user }, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation,
                                 :first_name, :last_name)
  end
end
