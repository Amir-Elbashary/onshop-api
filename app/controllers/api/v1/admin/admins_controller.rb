class Api::V1::Admin::AdminsController < Api::V1::Admin::BaseAdminController
  load_and_authorize_resource
  skip_load_resource

  swagger_controller :admins, 'Admin'

  swagger_api :update do
    summary 'Updating admin info'
    notes "Update admin profile info"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Admin Authentication Token'
    param :form, 'admin[first_name]', :string, :required, 'Admin first name'
    param :form, 'admin[last_name]', :string, :required, 'Admin last name'
    response :ok
    response :unauthorized
    response :unprocessable_entity
  end

  def update
    if @current_admin.update(admin_params)
      render json: { message: 'admin has been updated', admin: @current_admin }, status: :ok
    else
      render json: @current_admin.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def admin_params
    params.require(:admin).permit(:email, :password, :password_confirmation, :first_name, :last_name)
  end
end
