class Api::V1::User::CartsController < Api::V1::User::BaseUserController
  load_and_authorize_resource
  before_action :check_ownership, only: %i[show clear]
  before_action :set_carts, only: :index
  before_action :set_active_cart, only: :active_cart

  swagger_controller :carts, 'User'

  swagger_api :index do
    summary 'Get all user carts'
    notes "This API get all user carts"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'User Authentication Token'
    response :ok
    response :unauthorized
  end

  def index
    return render json: @carts, status: :ok
  end

  swagger_api :show do
    summary 'Get user cart info'
    notes "This API get specific cart info along with it's items"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'User Authentication Token'
    param :path, :id, :integer, :required, 'Cart ID'
    response :ok
    response :unauthorized
  end

  def show
    render json: @cart, status: :ok if @cart
  end

  swagger_api :active_cart do
    summary 'Get/Create user active cart'
    notes "This API gets user's current active card or Creates one if no active one exists"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'User Authentication Token'
    response :ok
    response :unauthorized
  end

  def active_cart
    return render json: @active_cart, status: :ok if @active_cart
    @new_cart = Cart.create(user: current_user)
    render json: @new_cart, status: :ok
  end

  swagger_api :clear do
    summary 'Clear cart items'
    notes "This API clears user's cart items as long as it's unlocked!"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'User Authentication Token'
    param :path, :id, :integer, :required, 'Cart ID'
    response :ok
    response :unauthorized
    response :not_found
    response :unprocessable_entity
  end

  def clear
    return render json: { success: false, message: 'cart is locked, please cancel it\'s order first' }, status: :unprocessable_entity if @cart.locked? 

    render json: { success: true, message: 'cart cleared' }, status: :ok if @cart.items.destroy_all
  end

  private

  def check_ownership
    return render json: { message: 'not allowed, this cart does not belong to this user' }, status: :unauthorized unless current_user.carts.include?(@cart)
  end

  def set_carts
    @carts = current_user.carts
  end

  def set_active_cart
    @active_cart = current_user.carts.active.first
  end
end
