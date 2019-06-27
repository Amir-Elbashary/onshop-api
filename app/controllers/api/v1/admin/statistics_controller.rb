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
    @categories = Category.count
    @orders = 'Coming Soon'
    @users = User.count
    @visitors = 'Coming Soon'
    render json: { products: @products,
                   categories: @categories,
                   orders: @orders,
                   users: @users,
                   visitors: @visitors }, status: :ok
  end
end
