class Api::V1::User::OrdersController < Api::V1::User::BaseUserController
  load_and_authorize_resource
  before_action :set_cart, only: :create

  swagger_controller :orders, 'User'

  swagger_api :create do
    summary 'Creating Order'
    notes "This API will create order for the given cart and lock it!"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'User Authentication Token'
    param :form, 'order[user_id]', :integer, :required, 'User ID'
    param :form, 'order[cart_id]', :integer, :required, 'Cart ID'
    response :ok
    response :unauthorized
    response :unprocessable_entity
  end

  def create
    return render json: { message: 'cart does not belong to this user' }, status: :unprocessable_entity unless current_user.carts.include?(@cart)
    return render json: { message: 'order already exists' }, status: :unprocessable_entity if @cart.order
    return render json: { message: 'cart is empty' }, status: :unprocessable_entity unless @cart.items.any?

    return render json: @order.errors.full_messages, status: :unprocessable_entity unless @order.save

    items_prices = []
    @cart.items.each do |item|
      items_prices << (item.variant.price * item.quantity)
    end

    @order.total_items = @cart.items.pluck(:quantity).inject(:+)
    @order.total_price = items_prices.inject(:+)

    @cart.locked! if @order.save
  end

  swagger_api :destroy do
    summary 'Deleting/Canceling Order'
    notes "This API cancels the order and unlock the cart!"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'User Authentication Token'
    param :path, :id, :integer, :required, 'Order ID'
    response :ok
    response :unauthorized
    response :unprocessable_entity
    response :not_found
  end

  def destroy
    return render json: @order.errors.full_messages unless @order.destroy
    return render json: { message: 'this order does not belong to this user' }, status: :unauthorized if @order.user != current_user
    @cart = @order.cart
    @cart.unlocked! if @order.destroy
  end

  private

  def order_params
    params.require(:order).permit(:user_id, :cart_id)
  end

  def set_cart
    @cart = Cart.find(params[:order][:cart_id])
  end
end
