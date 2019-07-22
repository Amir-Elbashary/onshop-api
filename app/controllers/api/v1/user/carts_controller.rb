class Api::V1::User::CartsController < Api::V1::User::BaseUserController
  load_and_authorize_resource
  skip_load_resource
  before_action :set_cart, only: :show
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
    # Cart items is to be added soon within the cart object
    return render json: { message: 'not allowed, this cart does not belong to this user' }, status: :unauthorized unless current_user.carts.include?(@cart)
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

  private

  def set_cart
    @cart = Cart.find(params[:id])
  end

  def set_carts
    @carts = current_user.carts
  end

  def set_active_cart
    @active_cart = current_user.carts.active.first
  end
end
