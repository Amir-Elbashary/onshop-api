class Api::V1::Onshop::AppSettingsController < Api::V1::Onshop::BaseOnshopController
  skip_authorization_check
  before_action :set_app_settings

  swagger_controller :app_settings, 'Admin'

  swagger_api :index do
    summary 'Get App settings'
    notes 'Valid App token is needed only'
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :query, :loc, :string, 'Locale'
    response :ok
    response :unauthorized
  end

  def index; end

  private

  def set_app_settings
    @app_settings = AppSetting.first
  end
end
