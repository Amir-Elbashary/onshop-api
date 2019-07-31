class Api::V1::Merchant::DiscountsController < Api::V1::Merchant::BaseMerchantController
  load_and_authorize_resource
  skip_load_resource
  before_action :check_dates, only: :create
  before_action :set_products, except: :index
  before_action :check_ownership, except: :index

  swagger_controller :discounts, 'Merchant'

  swagger_api :create do
    summary 'Creating product discount by merchant'
    notes "Create a product discount"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Merchant Authentication Token'
    param :form, 'discount[merchant_id]', :integer, :required, 'Merchant ID'
    param :form, 'discount[product_ids]', :array, :required, 'Product IDs'
    param :form, 'discount[percentage]', :integer, :required, 'Percantage 0~100'
    param :form, 'discount[starts_at]', :datetime, :required, 'Discount start date'
    param :form, 'discount[ends_at]', :datetime, :required, 'Discount end date'
    param :form, 'discount[force]', :string, :required, 'true or false'
    param :query, :loc, :string, 'Locale'
    response :ok
    response :unauthorized
    response :unprocessable_entity
  end

  def create
    unless ['true', 'false'].include?(params[:discount][:force].downcase)
      return render json: { message: 'force params must be "true" or "false"' }, status: :unprocessable_entity
    end

    if params[:discount][:force] == 'false'
      return render json: { message: 'a product already have a discount', product_id: @existing_discount_product.id, product_name: @existing_discount_product.name }, status: :unprocessable_entity if existing_discounts?(@products)
    end

    @discounts = []

    @products.each do |product|
      product.discount&.destroy if params[:discount][:force] == 'true'

      discount = Discount.new(discount_params)
      discount.product = product
      return render json: { errors: discount.errors.full_messages }, status: :unprocessable_entity unless discount.save
      @discounts << discount
    end
  end

  swagger_api :index do
    summary 'Get merchant discounts'
    notes "Get all discounts of specific merchant"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Merchant Authentication Token'
    param :query, :loc, :string, 'Locale'
    response :ok
    response :unauthorized
  end

  def index
    @discounts = current_merchant.discounts
  end

  swagger_api :destroy do
    summary 'Deleting discount by merchant'
    notes "Delete a merchant discount"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Merchant Authentication Token'
    param :form, 'discount[product_ids]', :array, :required, 'Product IDs'
    response :ok
    response :unauthorized
    response :unprocessable_entity
    response :not_found
  end

  def destroy
    @products.each do |product|
      return render json: { error: 'an error occured, please try again later' }, status: :unprocessable_entity unless product.discount.destroy
    end
  end

  private

  def discount_params
    params.require(:discount).permit(:merchant_id, :percentage, :starts_at, :ends_at)
  end

  def set_products
    @products = Product.find(params[:discount][:product_ids])
  end

  def check_dates
    return render json: { error: 'end date can not be before start date' }, status: :unprocessable_entity if params[:discount][:ends_at] < params[:discount][:starts_at]
  end

  def check_ownership
    @products.each do |product|
      return render json: { message: 'a product does not belong to this merchant', product_id: product.id }, status: :unprocessable_entity if product.merchant != current_merchant
    end
  end

  def existing_discounts?(products)
    products.each do |product|
      if product.discount
        @existing_discount_product = product
        return true
      end
    end

    false
  end
end
