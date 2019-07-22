class Api::V1::Admin::AppSettingsController < Api::V1::Admin::BaseAdminController
  load_and_authorize_resource
  skip_load_resource
  before_action :set_app_settings

  swagger_controller :app_settings, 'Admin'

  swagger_api :index do
    summary 'Get App settings'
    notes 'Valid admin is token needed only'
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Admin Authentication Token'
    response :ok
    response :unauthorized
  end

  def index; end

  swagger_api :update do
    summary 'Update App settings'
    notes 'send "id" as an ID on path parameter, use it as placeholder since token is what is really needed'
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Admin Authentication Token'
    param :form, 'app_setting[name_en]', :string, :required, 'App English Name'
    param :form, 'app_setting[name_ar]', :string, :optional, 'App Arabic Name'
    param :form, 'app_setting[description_en]', :string, :optional, 'App English Description'
    param :form, 'app_setting[description_ar]', :string, :optional, 'App Arabic Description'
    param :form, 'app_setting[privacy_en]', :text, :optional, 'App English Privacy'
    param :form, 'app_setting[privacy_ar]', :text, :optional, 'App Arabic Privacy'
    param :form, 'app_setting[email]', :string, :optional, 'App Email'
    param :form, 'app_setting[keywords]', :array, :optional, 'Keywords'
    param :form, 'app_setting[logo]', :string, :optional, 'App English Description'
    response :ok
    response :unprocessable_entity
    response :unauthorized
  end

  def update
    unless @app_settings.update(app_setting_params)
      render json: @app_settings.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def app_setting_params
    params.require(:app_setting).permit(:name_en, :name_ar, :description_en, :description_ar,
                                        :privacy_en, :privacy_ar, :email, :keywords, :logo)
  end

  def set_app_settings
    @app_settings = AppSetting.first
  end
end
