class Api::V1::Admin::SubscriptionsController < Api::V1::Admin::BaseAdminController
  load_and_authorize_resource
  skip_load_resource only: :index
  before_action :set_subscriptions, only: :index

  swagger_controller :subscriptions, 'Admin'

  swagger_api :index do
    summary 'Listing all subscriptions'
    notes "This API lists all subscriptions available on the system"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Admin Authentication Token'
    param :query, :page, :integer, :optional, 'Page'
    response :ok
    response :unauthorized
  end

  def index
    return render json: { message: 'no subscriptions on the system' }, status: :ok unless @subscriptions.any?
  end

  swagger_api :toggle do
    summary 'Toggling subscription status'
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Admin Authentication Token'
    param :path, :id, :integer, :required, 'Subscription ID'
    response :ok
    response :not_found
    response :unauthorized
  end

  def toggle
    if @subscription.active?
      @subscription.inactive!
    else
      @subscription.active!
    end

    render json: { id: @subscription.id, status: @subscription.status }, status: :ok
  end

  swagger_api :destroy do
    summary 'Deleting subscription from OnShop'
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Admin Authentication Token'
    param :path, :id, :integer, :required, 'Subscription ID'
    response :ok
    response :unauthorized
    response :not_found
  end

  def destroy
    return unless @subscription.destroy
    render json: { message: 'subscription was canceled', subscription: @subscription }, status: :ok
  end

  private

  def set_subscriptions
    @subscriptions = Subscription.all.page(params[:page]).per_page(32)
  end
end
