class Api::V1::Admin::OrdersController < Api::V1::Admin::BaseAdminController
  load_and_authorize_resource
  skip_load_resource only: :index

  swagger_controller :orders, 'Admin'

  swagger_api :index do
    summary 'Get all orders'
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Admin Authentication Token'
    param :query, :page, :string, 'Page'
    response :ok
    response :not_found
    response :unauthorized
  end

  def index
    if Order.any?
      @orders = Order.all.page(params[:page]).per_page(32)
    else
      render json: { message: 'no orders found' }, status: :not_found
    end
  end

  swagger_api :show do
    summary 'Show order'
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Admin Authentication Token'
    param :path, :id, :integer, :required, 'Order ID'
    response :ok
    response :not_found
    response :unauthorized
  end

  def show; end

  swagger_api :confirm do
    summary 'Confirm order'
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Admin Authentication Token'
    param :path, :id, :integer, :required, 'Order ID'
    param :form, 'order[status]', :string, :required, 'pending or paid'
    response :ok
    response :not_found
    response :unauthorized
  end

  def confirm
    unless ['pending', 'paid'].include?(params[:order][:status].downcase)
      return render json: { message: 'only pending and paid are allowed as order status' }, status: :unprocessable_entity
    end

    return render json: @order.errors.full_messages unless @order.update(order_params)
  end

  private

  def order_params
    params.require(:order).permit(:status)
  end
end
