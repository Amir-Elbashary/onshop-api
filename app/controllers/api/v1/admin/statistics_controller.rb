class Api::V1::Admin::StatisticsController < Api::V1::Admin::BaseAdminController
  skip_authorization_check

  swagger_controller :statistics, 'Admin' 

  swagger_api :show do
    summary 'Show app Statistics'
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Admin Authentication Token'
    response :ok
    response :unauthorized
  end

  def show
    @products = Product.count
    @merchants = Merchant.count
    @categories = Category.count
    @orders = Order.count
    @paid_orders = Order.paid.count
    @pending_orders = Order.pending.count
    @users = User.count
    @visitors = 'Coming Soon'
    render json: { products: @products,
                   merchants: @merchants,
                   categories: @categories,
                   orders: @orders,
                   paid_orders: @paid_orders,
                   pending_orders: @pending_orders,
                   users: @users,
                   visitors: @visitors }, status: :ok
  end
end
