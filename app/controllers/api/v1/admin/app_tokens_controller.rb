class Api::V1::Admin::AppTokensController < Api::V1::Admin::BaseAdminController
  before_action :authenticate_admin

  def create
    AppToken.destroy_all
    @app_token = AppToken.create(title: 'OnShop')

    render json: { status: 'success', new_token: @app_token.token }
  end
end
