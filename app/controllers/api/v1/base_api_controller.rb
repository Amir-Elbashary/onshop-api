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

  def hmac_secret
    if Rails.env.production?
      Rails.application.secrets.secret_key_base
    else
      ENV['SECRET_KEY_BASE']
    end
  end

  def set_expiration_time
    @exp = if params[:exp]
             Time.now.to_i + params[:exp].to_i
           else
             Time.now.to_i + 7 * 24 * 60 * 60
           end
  end

  def set_locale
    I18n.locale = if params[:loc] == 'en'
                    :en
                  elsif params[:loc] == 'ar'
                    :ar
                  else
                    I18n.default_locale
                  end
  end
end
