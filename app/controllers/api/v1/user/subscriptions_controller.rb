class Api::V1::User::SubscriptionsController < Api::V1::User::BaseUserController
  skip_authorization_check
  skip_before_action :authenticate_user
  before_action :set_subscription

  swagger_controller :subscriptions, 'User'

  swagger_api :create do
    summary 'Creating new subscription'
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :form, 'subscription[email]', :string, :required, 'User Email'
    response :created
    response :unprocessable_entity
    response :unauthorized
  end

  def create
    if @subscription.save
      render json: { success: true, email: @subscription.email }, status: :created
    else
      render json: { success: false, errors: @subscription.errors.full_messages }, status: :unprocessable_entity
    end
  end

  swagger_api :toggle do
    summary 'Toggle subscription status'
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :form, 'subscription[email]', :string, :required, 'User Email'
    response :ok
    response :not_found
    response :unauthorized
  end

  def toggle
    @subscription = Subscription.find_by(email: params[:subscription][:email])

    return render json: { error: 'email not found' }, status: :not_found unless @subscription

    if @subscription.active?
      @subscription.inactive!
      @subscription_status = 'deactivated'
    else
      @subscription.active!
      @subscription_status = 'activated'
    end

    render json: { success: true, status: @subscription_status }, status: :ok
  end

  private

  def subscription_params
    params.require(:subscription).permit(:email)
  end

  def set_subscription
    @subscription = Subscription.new(subscription_params)
  end
end
