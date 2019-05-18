class Api::V1::User::SessionsController < Api::V1::User::BaseUserController
  skip_authorization_check
  skip_before_action :authenticate_user

  swagger_controller :sessions, 'User'

  swagger_api :create do
    summary 'Sign in To OnShop'
    notes <<-eos
      Signing in should give you `authentication_token`.<br />
      You should add `authentication_token` to all upgoing requests
      in header to authenticate your self!<br />
      Header should be like this:</br>
      <b>X-User-Token</b> 1G8_s7P-V-4MGojaKD7a<br />
      <br />
    eos
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :form, 'user[email]', :email, :required, 'User Email'
    param :form, 'user[password]', :password, :required, 'User password'
    response :ok
    response :unprocessable_entity
    response :unauthorized
  end

  def create
    user_email = params[:user][:email]
    user_password = params[:user][:password]
    @user = User.find_for_database_authentication(email: user_email)
    if @user
      if @user.valid_password?(user_password)
        sign_in @user, store: false
        @user.generate_authentication_token!
        @user.save
        render json: { success: true,
                       user_id: @user.id,
                       authentication_token: @user.authentication_token,
                       email: @user.email,
                       user_name: @user.full_name }
      else
        render json: { errors: 'Invalid email or password' }, status: :unprocessable_entity
      end
    else
      render json: { errors: 'You should sign up first' }, status: :unprocessable_entity
    end
  end

  swagger_api :destroy do
    summary 'Sign out'
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'User Authentication Token'
    response :ok
    response :unauthorized
  end

  def destroy
    @user = current_user
    if current_user
      @user.generate_authentication_token!
      @user.save
      render json: { success: true, status: 'signed out' }, status: :ok
    else
      render json: { error: 'unauthorized access' }, status: :unauthorized
    end
  end
end
