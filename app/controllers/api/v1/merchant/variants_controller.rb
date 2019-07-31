class Api::V1::Merchant::VariantsController < Api::V1::Merchant::BaseMerchantController
  load_and_authorize_resource
  skip_load_resource only: :index
  before_action :set_product
  before_action :set_variants, only: %i[index]
  before_action :require_same_merchant

  swagger_controller :variants, 'Merchant'

  swagger_api :create do
    summary 'Creating product variant by merchant'
    notes "Create a product variant"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Merchant Authentication Token'
    param :form, 'variant[product_id]', :integer, :required, 'Merchant ID'
    param :form, 'variant[name_en]', :string, :optional, 'Variant name'
    param :form, 'variant[name_ar]', :string, :optional, 'Variant arabic name'
    param :form, 'variant[color_en]', :string, :required, 'Product variant color'
    param :form, 'variant[color_ar]', :string, :optional, 'Product variant color'
    param :form, 'variant[size_en]', :text, :optional, 'Product variant size'
    param :form, 'variant[size_ar]', :text, :optional, 'Product variant size'
    param :form, 'variant[price]', :text, :required, 'Product variant price'
    param :form, 'variant[quantity]', :text, :optional, 'Product variant quantity'
    param :form, 'variant[image]', :string, :required, 'Product variant image'
    response :ok
    response :unauthorized
    response :unprocessable_entity
  end

  def create
    if @variant.save
      render json: { message: 'product variant has been added', product: @product, variants: @product.variants }, status: :created
    else
      render json: @variant.errors.full_messages, status: :unprocessable_entity
    end
  end

  swagger_api :index do
    summary 'Get merchant product variants'
    notes "Get all product variants of specific merchant"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Merchant Authentication Token'
    param :path, :product_id, :integer, :required, 'Product ID'
    param :query, :loc, :string, 'Locale'
    response :ok
    response :unauthorized
    response :unprocessable_entity
    response :not_found
  end

  def index; end

  swagger_api :show do
    summary 'Get merchant product variant'
    notes "Shows specific variant and it's product"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Merchant Authentication Token'
    param :path, :product_id, :integer, :required, 'Product ID'
    param :path, :id, :integer, :required, 'Variant ID'
    param :query, :loc, :string, 'Locale'
    response :ok
    response :unauthorized
    response :unprocessable_entity
    response :not_found
  end

  def show; end

  swagger_api :update do
    summary 'Update product variant by merchant'
    notes "Update a product variant info"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Merchant Authentication Token'
    param :path, :product_id, :integer, :required, 'Product ID'
    param :path, :id, :integer, :required, 'Variant ID'
    param :form, 'variant[name_en]', :string, :optional, 'Variant name'
    param :form, 'variant[name_ar]', :string, :optional, 'Variant arabic name'
    param :form, 'variant[color_en]', :string, :required, 'Product variant color'
    param :form, 'variant[color_ar]', :string, :optional, 'Product variant color'
    param :form, 'variant[size_en]', :text, :optional, 'Product variant size'
    param :form, 'variant[size_ar]', :text, :optional, 'Product variant size'
    param :form, 'variant[price]', :text, :required, 'Product variant price'
    param :form, 'variant[quantity]', :text, :optional, 'Product variant quantity'
    param :form, 'variant[image]', :string, :required, 'Product variant image'
    response :ok
    response :unauthorized
    response :unprocessable_entity
  end

  def update
    if @variant.update(variant_params)
      render json: { message: 'product variant info has been updated', variant: @variant.as_json.merge(name_en: @variant.name_en, name_ar: @variant.name_ar) }, status: :ok
    else
      render json: @variant.errors.full_messages, status: :unprocessable_entity
    end
  end

  swagger_api :destroy do
    summary 'Deleting product variant by merchant'
    notes "Delete a product variant"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Merchant Authentication Token'
    param :path, :id, :integer, :required, 'Product Variant ID'
    response :ok
    response :unauthorized
    response :unprocessable_entity
    response :not_found
  end

  def destroy
    return render json: { error: 'an error occured' }, status: :unprocessable_entity unless @variant.destroy
    render json: { message: 'product variant was deleted', variant: @variant }, status: :ok
  end

  private

  def variant_params
    params.require(:variant).permit(:product_id, :name_en, :name_ar, :color_en, :color_ar,
                                    :quantity, :size_en, :size_ar, :price, :image)
  end

  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_variants
    @variants = @product.variants
  end

  def require_same_merchant
    return render json: { error: 'you can only access your own products' }, status: :unprocessable_entity unless current_merchant.products.include?(@product)
  end
end
