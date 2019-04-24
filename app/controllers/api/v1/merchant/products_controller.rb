class Api::V1::Merchant::ProductsController < Api::V1::Merchant::BaseMerchantController
  load_and_authorize_resource

  def create
    if @product.save
      render json: { message: 'product has been created', product: @product }, status: :created
    else
      render json: @product.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def product_params
    params.require(:product).permit(:merchant_id, :category_id, :name, :description, :image)
  end
end
