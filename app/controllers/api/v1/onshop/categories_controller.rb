class Api::V1::Onshop::CategoriesController < Api::V1::Onshop::BaseOnshopController
  load_and_authorize_resource except: :index
  skip_authorization_check only: :index
  skip_load_resource
  before_action :set_category, only: :index
  # skip_before_action :authenticate_user, only: :index

  swagger_controller :categories, 'OnShop'

  swagger_api :index do
    summary 'Listin categories'
    notes "Listing and filtering categories"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :query, :loc, :string, 'Locale'
    param :query, :category_id, :integer, 'Category ID'
    param :query, :page, :integer, 'Page'
    response :ok
    response :unauthorized
    response :unprocessable_entity
    response :not_found
  end

  def index
    @categories = Category.roots.page(params[:page]).per_page(32) unless params[:category_id]
  end

  private

  def set_category
    @category = Category.find(params[:category_id]) if params[:category_id]
  end
end
