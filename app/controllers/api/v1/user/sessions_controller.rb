class Api::V1::User::SessionsController < Api::V1::User::BaseUserController
  skip_authorization_check
  skip_before_action :authenticate_user
  before_action :set_user, only: :create
  before_action :set_expiration_time, only: :create

  swagger_controller :sessions, 'User'

  swagger_api :create do
    summary 'Sign in To OnShop'
    notes <<-eos
      Signing in should give you JWT Token.<br />
      You should add this token to all upgoing requests
      in header to authenticate your self!<br />
      Header should be like this:</br>
      <b>X-User-Token</b> your_token<br />
      <br />
      exp is the expiry time and you should enter it to seconds<br/>
      Assuming we need 2 days: exp = 2 * 24 * 60 * 60<br/>
      Default timeout is 1 week
    eos
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :form, 'user[email]', :string, :required, 'User Email'
    param :form, 'user[password]', :string, :required, 'User Password'
    param :query, :exp, :integer, :optional, 'Exiration time in seconds'
    response :ok
    response :unprocessable_entity
    response :unauthorized
  end

  def create
    if @user
      if @user.valid_password?(@user_password)
        payload = { email: @user_email, exp: @exp }
        token = JWT.encode(payload, hmac_secret, 'HS256')

        @login = Login.create(user: @user, token: token, ip_address: request.remote_ip, agent: request.user_agent) if token

        render json: { success: true,
                       token: token,
                       user: @user.as_json(except: :authentication_token),
                       login: @login.as_json(except: :token) }, status: :ok
      else
        render json: { success: false, errors: 'invalid email or password' }, status: :unprocessable_entity
      end
    else
      render json: { success: false, errors: 'you should sign up first' }, status: :unprocessable_entity
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
    if current_user
      @current_login.token = nil
      @current_login.save
      render json: { message: 'logged out successfully' }, status: :ok
    else
      render json: { message: 'session expired or user already logged out' }, status: :unauthorized
    end
  end

  private

  def set_user
    @user_email = params[:user][:email]
    @user_password = params[:user][:password]
    @user = User.find_for_database_authentication(email: @user_email)
  end
end
