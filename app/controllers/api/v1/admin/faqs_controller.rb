class Api::V1::Admin::FaqsController < Api::V1::Admin::BaseAdminController
  load_and_authorize_resource

  swagger_controller :faqs, 'Admin'

  swagger_api :create do
    summary 'Creating new FAQ'
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Admin Authentication Token'
    param :form, 'faq[question_en]', :text, :required, 'FAQ English Question'
    param :form, 'faq[question_ar]', :text, :optional, 'FAQ Arabic Question'
    param :form, 'faq[answer_en]', :text, :required, 'FAQ English Answer'
    param :form, 'faq[answer_ar]', :text, :optional, 'FAQ Arabic Answer'
    response :ok
    response :unprocessable_entity
    response :unauthorized
  end

  def create
    unless @faq.save
      render json: { error: @faq.errors.full_messages }, status: :unprocessable_entity
    end
  end

  swagger_api :update do
    summary 'Updating FAQ'
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Admin Authentication Token'
    param :path, :id, :integer, :required, 'FAQ ID'
    param :form, 'faq[question_en]', :text, :required, 'FAQ English Question'
    param :form, 'faq[question_ar]', :text, :optional, 'FAQ Arabic Question'
    param :form, 'faq[answer_en]', :text, :required, 'FAQ English Answer'
    param :form, 'faq[answer_ar]', :text, :optional, 'FAQ Arabic Answer'
    response :ok
    response :unprocessable_entity
    response :not_found
    response :unauthorized
  end

  def update
    unless @faq.update(faq_params)
      render json: { error: @faq.errors.full_messages }, status: :unprocessable_entity
    end
  end

  swagger_api :index do
    summary 'Listing all FAQs'
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Admin Authentication Token'
    response :ok
    response :unauthorized
  end

  def index; end

  swagger_api :show do
    summary 'Showing FAQ data'
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Admin Authentication Token'
    param :path, :id, :integer, :required, 'FAQ ID'
    response :ok
    response :not_found
    response :unauthorized
  end

  def show; end

  swagger_api :destroy do
    summary 'Deleting FAQ'
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Admin Authentication Token'
    param :path, :id, :integer, :required, 'FAQ ID'
    response :ok
    response :not_found
    response :unauthorized
  end

  def destroy
    unless @faq.destroy
      render json: { error: @faq.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def faq_params
    params.require(:faq).permit(:question_en, :question_ar, :answer_en, :answer_ar)
  end
end
