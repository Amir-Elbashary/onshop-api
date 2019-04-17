class Api::V1::BaseApiController < ApplicationController
  # protect_from_forgery with: :null_session, if: proc { |c| c.request.format == 'application/json' }
  respond_to :json
  rescue_from ActiveRecord::RecordNotFound, ActiveRecord::InvalidForeignKey, with: :not_found
  before_action :authenticate_app_token!

  def not_found
    render json: { error: 'object not found, or does not exists' }, status: :not_found
  end

  private

  def authenticate_app_token!
    return if AppToken.where(token: request.headers['X-APP-TOKEN']).exists?
    render json: { error: 'unauthorized access' }, status: :unauthorized
  end
end
