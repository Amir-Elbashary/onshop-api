class Api::V1::User::OrdersController < Api::V1::User::BaseUserController
  load_and_authorize_resource
  skip_load_resource only: :create
  before_action :set_cart, only: :create
  before_action :set_order, only: :checkout
  before_action :set_coupon, only: :coupon

  swagger_controller :orders, 'User'

  swagger_api :create do
    summary 'Creating Order'
    notes "This API will create order for the given cart and lock it!"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'User Authentication Token'
    param :form, 'order[user_id]', :integer, :required, 'User ID'
    param :form, 'order[cart_id]', :integer, :required, 'Cart ID'
    param :form, 'order[payment_method]', :string, :required, 'cash or paypal'
    response :ok
    response :unauthorized
    response :unprocessable_entity
  end

  def create
    unless ['cash', 'paypal'].include?(params[:order][:payment_method].downcase)
      return render json: { message: 'only cash and paypal are allowed as payment methods' }, status: :unprocessable_entity
    end

    return render json: { message: 'cart does not belong to this user' }, status: :unprocessable_entity unless current_user.carts.include?(@cart)
    return render json: { message: 'order already exists' }, status: :unprocessable_entity if @cart.order
    return render json: { message: 'cart is empty' }, status: :unprocessable_entity unless @cart.items.any?

    @order = Order.new(order_params)

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

  swagger_api :checkout do
    summary 'Checking out Order'
    notes "This API checking out the order and deactivate the cart!"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'User Authentication Token'
    param :path, :id, :integer, :required, 'Order ID'
    param :query, :success, :string, :required, 'true or false'
    response :ok
    response :unauthorized
    response :unprocessable_entity
    response :not_found
  end

  def checkout
    return render json: { error: 'this order does not belong to this user' }, status: :unauthorized unless current_user.orders.include?(@order)

    if params[:success].downcase == 'true'
      @order.cart.inactive!
      render json: { message: 'checkout successful, cart closed' }, status: :ok
    elsif params[:success].downcase == 'false'
      @order.cart.active!
      render json: { message: 'checkout failed, cart still opened' }, status: :unprocessable_entity
    else
      return render json: { message: 'send true or false as success param' }, status: :unprocessable_entity
    end
  end

  swagger_api :coupon do
    summary 'Applying coupon to order'
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'User Authentication Token'
    param :path, :id, :integer, :required, 'Order ID'
    param :form, 'order[coupon_code]', :string, :optional, 'Coupon Code'
    response :ok
    response :unauthorized
    response :unprocessable_entity
    response :not_found
  end

  def coupon
    return render json: { error: 'this order does not belong to this user' }, status: :unauthorized unless current_user.orders.include?(@order)
    return render json: { error: 'this coupon code is invalid or has expired' }, status: :unprocessable_entity unless @coupon&.active?

    if @coupon.active?
      @order.update(order_params)
      render json: { message: 'coupon successfully added',
                     valid_from: @coupon.starts_at.strftime('%d-%m-%Y'),
                     valid_to: @coupon.ends_at.strftime('%d-%m-%Y'),
                     discount: "#{@coupon.percentage}%" }, status: :ok
    end
  end

  private

  def order_params
    params.require(:order).permit(:user_id, :cart_id, :payment_method, :coupon_code)
  end

  def set_cart
    @cart = Cart.find(params[:order][:cart_id])
  end

  def set_order
    @order = Order.find(params[:id])
  end

  def set_coupon
    @coupon = Coupon.find_by(code: params[:order][:coupon_code])
  end
end
