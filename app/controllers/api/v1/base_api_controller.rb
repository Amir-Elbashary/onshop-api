class Api::V1::BaseApiController < ApplicationController
  respond_to :json
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::InvalidForeignKey, with: :has_relations
  rescue_from JWT::ExpiredSignature, with: :session_expired
  before_action :authenticate_app_token!
  before_action :set_locale

  def not_found
    render json: { error: 'object not found, or does not exists' }, status: :not_found
  end

  def has_relations
    render json: { error: 'this object is associated with other objects, please delete them first' }, status: :forbidden
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

  def session_expired
    login ||= Login.find_by(token: request.headers['X-User-Token'])
    login.token = nil
    login.save
    render json: { message: 'session expired, please relogin' }, status: :unauthorized
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
