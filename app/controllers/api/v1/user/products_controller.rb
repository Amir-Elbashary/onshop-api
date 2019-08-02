class Api::V1::User::ProductsController < Api::V1::User::BaseUserController
  load_and_authorize_resource
  before_action :set_favourite_product

  swagger_controller :products, 'User'

  swagger_api :favourite_product do
    summary 'Adding/Removing product from favourites'
    notes "Adding/Removing products to/from favourites working as toggling"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'User Authentication Token'
    param :path, :id, :integer, :required, 'Product ID'
    response :ok
    response :unauthorized
    response :not_found
  end

  def favourite_product
    if @favourite_product
      @favourite_product.destroy
      render json: { message: 'product was removed from favourites' }, status: :ok
    else
      Favourite.create(user: current_user, favourited: @product)
      render json: { message: 'product has been added to favourites' }, status: :ok
    end
  end

  swagger_api :is_favourite do
    summary 'Checking product existance in user favourites'
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'User Authentication Token'
    param :path, :id, :integer, :required, 'Product ID'
    response :ok
    response :unauthorized
    response :not_found
  end

  def is_favourite; end

  private

  def product_params
    params.require(:product).permit(:merchant_id, :category_id, :name_en, :name_ar,
                                    :description_en, :description_ar, :image)
  end

  def set_favourite_product
    @favourite_product = Favourite.where(user: current_user, favourited: @product).first
  end
end
