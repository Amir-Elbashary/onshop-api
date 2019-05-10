class Api::V1::BaseApiController < ApplicationController
  respond_to :json
  rescue_from ActiveRecord::RecordNotFound, ActiveRecord::InvalidForeignKey, with: :not_found
  before_action :authenticate_app_token!
  before_action :set_locale

  def not_found
    render json: { error: 'object not found, or does not exists' }, status: :not_found
  end

  private

  def authenticate_app_token!
    return if AppToken.where(token: request.headers['X-APP-TOKEN']).exists?
    render json: { error: 'unauthorized access' }, status: :unauthorized
  end

  def set_locale 
    if params[:loc] == 'en'
      I18n.locale = :en
    elsif params[:loc] == 'ar'
      I18n.locale = :ar 
    else
      I18n.default_locale
    end
  end
end
