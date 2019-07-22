class Api::V1::Onshop::FaqsController < Api::V1::Onshop::BaseOnshopController
  skip_authorization_check
  before_action :set_faqs

  swagger_controller :faqs, 'OnShop'

  swagger_api :index do
    summary 'Get all FAQs'
    notes 'Valid App token is needed only'
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    response :ok
    response :unauthorized
  end

  def index; end

  private

  def set_faqs
    @faqs = Faq.all
  end
end
