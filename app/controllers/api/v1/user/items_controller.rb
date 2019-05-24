class Api::V1::User::ItemsController < Api::V1::User::BaseUserController
  load_and_authorize_resource
  skip_load_resource
  before_action :set_cart
  before_action :set_item, only: %i[update destroy]
  before_action :set_variant, except: %i[index destroy]
  before_action :require_same_user
  before_action :check_quantity, only: %i[create update]

  swagger_controller :items, 'User'

  swagger_api :create do
    summary 'Adding items to cart'
    notes "Adding items in carts initially, then quantity can be updated on PUT APIs"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'User Authentication Token'
    param :path, :cart_id, :integer, :required, 'Cart ID'
    param :form, 'item[variant_id]', :integer, :required, 'Variant ID'
    param :form, 'item[quantity]', :integer, :required, 'Item Quantity'
    response :ok
    response :unauthorized
    response :unprocessable_entity
    response :not_found
  end

  def create
    @item = @cart.items.where(variant: @variant).first

    if @item
      check_quantity
    else
      @item = Item.new(item_params)
      @item.cart = @cart
    end

    if @item.save
      render json: { message: 'item added to cart', variant: @variant, product: @variant.product }, status: :ok
    else
      render json: @item.errors.full_messages, status: :unprocessable_entity
    end
  end

  swagger_api :index do
    summary 'Listing cart items'
    notes "Listing all items in this card for specific user"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'User Authentication Token'
    param :path, :cart_id, :integer, :required, 'Cart ID'
    response :ok
    response :unauthorized
    response :not_found
  end

  def index
    render json: @cart.items, status: :ok
  end

  swagger_api :update do
    summary 'Updating item\'s quantities on cart'
    notes "This APIs is used to update cart items quantities"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'User Authentication Token'
    param :path, :cart_id, :integer, :required, 'Cart ID'
    param :path, :id, :integer, :required, 'Item ID'
    param :form, 'item[variant_id]', :integer, :required, 'Variant ID'
    param :form, 'item[quantity]', :integer, :required, 'item quantity'
    response :ok
    response :unauthorized
    response :unprocessable_entity
    response :not_found
  end

  def update
    if @item.update(quantity: params[:item][:quantity])
      render json: { message: 'item quantity updated', quantity: @item.quantity }, status: :ok
    else
      render json: { message: 'an error occured, please try again' }, state: :unprocessable_entity
    end
  end

  swagger_api :destroy do
    summary 'Removing item from user cart'
    notes "Here you can remove item which has been added to cart"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'User Authentication Token'
    param :path, :cart_id, :integer, :required, 'Cart ID'
    param :path, :item_id, :integer, :required, 'Item ID'
    response :ok
    response :unauthorized
    response :unprocessable_entity
    response :not_found
  end

  def destroy
    if @cart.items.include?(@item) && @item.destroy
      render json: { message: 'item removed from cart' }, status: :ok
    else
      render json: { message: 'an error occured, or this item does not belong to this cart, please try another item or try again later' }, status: :unprocessable_entity
    end
  end

  private

  def item_params
    params.require(:item).permit(:variant_id, :quantity)
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def set_cart
    @cart = Cart.find(params[:cart_id])
  end

  def set_variant
    @variant = Variant.find(params[:item][:variant_id])
  end

  def require_same_user
    return render json: { message: 'you can only access this user\'s own carts' }, status: :unauthorized unless current_user.carts.include?(@cart)
  end

  def check_quantity
    return render json: { message: "this variant has only #{@variant.quantity} in stock" }, status: :unprocessable_entity if params[:item][:quantity].to_i > @variant.quantity
  end
end
