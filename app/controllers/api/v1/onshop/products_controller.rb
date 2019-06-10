class Api::V1::Onshop::ProductsController < Api::V1::Onshop::BaseOnshopController
  load_and_authorize_resource except: %i[index show]
  skip_authorization_check only: %i[index show]
  skip_load_resource
  before_action :set_category, only: :index
  before_action :set_product, only: :show
  # skip_before_action :authenticate_user, only: :index

  swagger_controller :products, 'OnShop'

  swagger_api :index do
    summary 'Listin products'
    notes "Listing and filtering products"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :query, :loc, :string, 'Locale'
    param :query, :category_id, :integer, 'Category ID'
    param :query, :search, :string, 'Search'
    param :query, :page, :string, 'Page'
    response :ok
    response :unauthorized
    response :unprocessable_entity
    response :not_found
  end

  def index
    @products = Product.all.page(params[:page]).per_page(32)
    @products = @category.products.page(params[:page]).per_page(32) if params[:category_id]

    if params[:category_id]   
      if @category.root?      
        @products = Product.where(category: @category.children)
      else                    
        @products = @category.products.page(params[:page]).per_page(32)
      end
    end

    @products = @products.with_translations.where('lower(product_translations.name) like ?', "%#{params[:search].downcase.strip.squeeze}%") if params[:search]
  end

  swagger_api :show do
    summary 'Showing Product'
    notes "Showing product info with it's variants"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :path, :id, :integer, :required, 'Product ID'
    param :query, :loc, :string, 'Locale'
    response :ok
    response :unauthorized
    response :unprocessable_entity
    response :not_found
  end

  def show
    render json: @product.to_json(include: :variants), status: :ok
  end

  private

  def set_category
    @category = Category.find(params[:category_id]) if params[:category_id]
  end

  def set_product
    @product = Product.find(params[:id])
  end
end
