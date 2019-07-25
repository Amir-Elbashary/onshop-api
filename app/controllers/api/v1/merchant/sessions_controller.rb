class Api::V1::Merchant::SessionsController < Api::V1::Merchant::BaseMerchantController
  skip_authorization_check
  skip_before_action :authenticate_merchant
  before_action :set_merchant, only: :create
  before_action :set_expiration_time, only: :create

  swagger_controller :sessions, 'Merchant'

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
    param :form, 'merchant[email]', :email, :required, 'Merchant Email'
    param :form, 'merchant[password]', :password, :required, 'Merchant password'
    param :query, :exp, :integer, :optional, 'Exiration time in seconds'
    response :ok
    response :unprocessable_entity
    response :unauthorized
  end

  def create
    if @merchant
      if @merchant.valid_password?(@merchant_password)
        payload = { email: @merchant_email, exp: @exp }
        token = JWT.encode(payload, hmac_secret, 'HS256')

        @login = Login.create(merchant: @merchant, token: token, ip_address: request.remote_ip, agent: request.user_agent) if token

        render json: { success: true,
                       token: token,
                       merchant: @merchant.as_json(except: :authentication_token),
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
    param :header, 'X-User-Token', :string, :required, 'Merchant Authentication Token'
    response :ok
    response :unauthorized
  end

  def destroy
    if current_merchant
      @current_login.token = nil
      @current_login.save
      render json: { message: 'logged out successfully' }, status: :ok
    else
      render json: { message: 'session expired or user already logged out' }, status: :unauthorized
    end
  end

  private

  def set_merchant
    @merchant_email = params[:merchant][:email]
    @merchant_password = params[:merchant][:password]
    @merchant = Merchant.find_for_database_authentication(email: @merchant_email)
  end
end
