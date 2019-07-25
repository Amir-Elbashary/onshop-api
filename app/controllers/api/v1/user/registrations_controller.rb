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
    param :form, 'user[gender]', :string, :optional, 'User gender'
    response :ok
    response :unauthorized
    response :unprocessable_entity
  end

  def create
    if params[:user][:gender].present? && !['unspecified', 'male', 'female'].include?(params[:user][:gender])
      return render json: { message: 'only unspecified, male and female are allowed as gender, or leave it blank' }, status: :unprocessable_entity
    end

    @user = User.new(user_params)

    if @user.save
      payload = { email: @user.email, exp: 86400 }
      token = JWT.encode(payload, hmac_secret, 'HS256')

      @login = Login.create(user: @user, token: token, ip_address: request.remote_ip, agent: request.user_agent) if token

      render json: { success: true,
                     token: token,
                     user: @user.as_json(except: :authentication_token),
                     login: @login.as_json(except: :token) }, status: :ok
    else
      render json: { success: false, errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  swagger_api :social_media do
    summary "Signup, or signin using Social Media"
    param :header, "X-APP-Token", :string, :required, "App Authentication Token"
    param :form, "user[email]", :email, :required, "User Email"
    param :form, "user[first_name]", :name, :required, "User Name"
    param :form, "user[last_name]", :name, :required, "User Name"
    param_list :form, "user[provider]", :provider, :required, "User provider", ["Facebook", "Gmail"]
    param :form, "user[uid]", :uid, :required, "User Identifier on Social Media"
    response :ok
    response :bad_request
  end   
        
  def social_media
    user = User.from_omniauth(construct_authhash)
    payload = { email: user.email }
    token = JWT.encode(payload, hmac_secret, 'HS256')


    if user.persisted?
      login = user.logins.first

      if login
        unless login.token
          login.token = token
          login.save
        end
      else
        Login.create(user: user, token: token, ip_address: request.remote_ip, agent: request.user_agent) if token
      end

      user.email = nil if user.email.partition('@').last == "onshop.com"

      render json: { token: user.logins.first.token, user: user.as_json(except: :authentication_token) }, status: :ok
    else
      render json: { errors: user.errors }, status: :bad_request
    end 
  end
        
  private

  def construct_authhash
    OmniAuth::AuthHash.new(uid: permitted_params[:uid], first_name: permitted_params[:first_name],
                           last_name: permitted_params[:last_name], provider: permitted_params[:provider],
                           info: { email: permitted_params.fetch(:email, nil) })
  end   
        
  def permitted_params         
    params.require(:user).permit(:email, :first_name, :last_name, :provider, :uid)
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation,
                                 :first_name, :last_name, :gender)
  end
end
