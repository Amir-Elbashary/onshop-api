class Api::V1::Merchant::SessionsController < Api::V1::Merchant::BaseMerchantController
  skip_before_action :authenticate_merchant

  swagger_controller :sessions, 'Merchant'

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
    param :form, 'merchant[email]', :email, :required, 'Merchant Email'
    param :form, 'merchant[password]', :password, :required, 'Merchant password'
    response :ok
    response :unprocessable_entity
    response :unauthorized
  end

  def create
    merchant_email = params[:merchant][:email]
    merchant_password = params[:merchant][:password]
    @merchant = Merchant.find_for_database_authentication(email: merchant_email)
    if @merchant
      if @merchant.valid_password?(merchant_password)
        sign_in @merchant, store: false
        @merchant.generate_authentication_token!
        @merchant.save
        render json: { success: true,
                       authentication_token: @merchant.authentication_token,
                       email: @merchant.email,
                       user_name: @merchant.full_name }
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
    param :header, 'X-User-Token', :string, :required, 'Merchant Authentication Token'
    response :ok
    response :unauthorized
  end

  def destroy
    @merchant = current_merchant
    if current_merchant
      @merchant.generate_authentication_token!
      @merchant.save
      render json: { success: true, status: 'signed out' }, status: :ok
    else
      render json: { error: 'unauthorized access' }, status: :unauthorized
    end
  end
end
