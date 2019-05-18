class Api::V1::Merchant::ProductsController < Api::V1::Merchant::BaseMerchantController
  load_and_authorize_resource
  skip_load_resource only: :index
  before_action :require_same_merchant, except: %i[create index]

  swagger_controller :products, 'Merchant'

  swagger_api :create do
    summary 'Creating product by merchant'
    notes "Create a product to be pending approval of admins"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Merchant Authentication Token'
    param :form, 'product[merchant_id]', :integer, :required, 'Merchant ID'
    param :form, 'product[category_id]', :integer, :required, 'Category ID'
    param :form, 'product[name_en]', :string, :required, 'Product name'
    param :form, 'product[name_ar]', :string, :optional, 'Product name'
    param :form, 'product[description_en]', :text, :optional, 'Product description'
    param :form, 'product[description_ar]', :text, :optional, 'Product description'
    param :form, 'product[image]', :string, :required, 'Product cover image'
    response :ok
    response :unauthorized
    response :unprocessable_entity
  end

  def create
    if @product.save
      render json: { message: 'product has been created', product: @product }, status: :created
    else
      render json: @product.errors.full_messages, status: :unprocessable_entity
    end
  end

  swagger_api :update do
    summary 'Updating product by merchant'
    notes "Update a product info"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Merchant Authentication Token'
    param :path, :id, :integer, :required, 'Product ID'
    param :form, 'product[category_id]', :integer, :required, 'Category ID'
    param :form, 'product[name_en]', :string, :required, 'Product name'
    param :form, 'product[name_ar]', :string, :optional, 'Product name'
    param :form, 'product[description_en]', :text, :optional, 'Product description'
    param :form, 'product[description_ar]', :text, :optional, 'Product description'
    param :form, 'product[image]', :string, :required, 'Product cover image'
    response :ok
    response :unauthorized
    response :unprocessable_entity
  end

  def update
    if @product.update(product_params)
      render json: { message: 'product info has been updated', product: @product }, status: :ok
    else
      render json: @product.errors.full_messages, status: :unprocessable_entity
    end
  end

  swagger_api :index do
    summary 'Get merchant products'
    notes "Get all products of specific merchant"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Merchant Authentication Token'
    param :query, :page, :string, 'Page'
    param :query, :loc, :string, 'Locale'
    response :ok
    response :unauthorized
    response :unprocessable_entity
    response :not_found
  end

  def index
    @products = current_merchant.products.page(params[:page]).per_page(32)
  end

  swagger_api :show do
    summary 'Get merchant product'
    notes "Get all info of a specific product and it's variants"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Merchant Authentication Token'
    param :path, :id, :integer, :required, 'Product ID'
    param :query, :loc, :string, 'Locale'
    response :ok
    response :unauthorized
    response :unprocessable_entity
    response :not_found
  end

  def show
    render json: @product.to_json(include: :variants)
  end

  swagger_api :destroy do
    summary 'Deleting product by merchant'
    notes "Delete a product"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Merchant Authentication Token'
    param :path, :id, :integer, :required, 'Product ID'
    response :ok
    response :unauthorized
    response :unprocessable_entity
    response :not_found
  end

  def destroy
    return render json: { error: 'an error occured' }, status: :unprocessable_entity unless @product.destroy
    render json: { message: 'product was deleted', product: @product }, status: :ok
  end

  private

  def product_params
    params.require(:product).permit(:merchant_id, :category_id, :name_en, :name_ar,
                                    :description_en, :description_ar, :image)
  end

  def require_same_merchant
    return render json: { error: 'you can only access your own products' }, status: :unprocessable_entity unless current_merchant.products.include?(@product)
  end
end
