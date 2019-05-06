class Api::V1::Admin::SessionsController < Api::V1::Admin::BaseAdminController
  skip_authorization_check
  skip_before_action :authenticate_admin

  swagger_controller :sessions, 'Admin'

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
    param :form, 'admin[email]', :email, :required, 'Admin Email'
    param :form, 'admin[password]', :password, :required, 'Admin password'
    response :ok
    response :unprocessable_entity
    response :unauthorized
  end

  def create
    admin_email = params[:admin][:email]
    admin_password = params[:admin][:password]
    @admin = Admin.find_for_database_authentication(email: admin_email)
    if @admin
      if @admin.valid_password?(admin_password)
        sign_in @admin, store: false
        @admin.generate_authentication_token!
        @admin.save
        render json: { success: true,
                       admin_id: @admin.id,
                       authentication_token: @admin.authentication_token,
                       email: @admin.email,
                       user_name: @admin.full_name }
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
    param :header, 'X-User-Token', :string, :required, 'Admin Authentication Token'
    response :ok
    response :unauthorized
  end

  def destroy
    @admin = current_admin
    if current_admin
      @admin.generate_authentication_token!
      @admin.save
      render json: { success: true, status: 'signed out' }, status: :ok
    else
      render json: { error: 'unauthorized access' }, status: :unauthorized
    end
  end
end
