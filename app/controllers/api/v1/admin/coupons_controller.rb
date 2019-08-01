class Api::V1::Admin::CouponsController < Api::V1::Admin::BaseAdminController
  load_and_authorize_resource
  # skip_load_resource
  before_action :check_dates, only: :create

  swagger_controller :coupons, 'Admin'

  swagger_api :create do
    summary 'Creating coupon by admin'
    notes "Create a coupon"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Admin Authentication Token'
    param :form, 'coupon[percentage]', :integer, :required, 'Percantage 0~100'
    param :form, 'coupon[starts_at]', :datetime, :required, 'Coupon start date'
    param :form, 'coupon[ends_at]', :datetime, :required, 'Coupon end date'
    response :ok
    response :unauthorized
    response :unprocessable_entity
  end

  def create
    return render json: { errors: @coupon.errors.full_messages }, status: :unprocessable_entity unless @coupon.save
  end

  swagger_api :index do
    summary 'Get all coupons'
    notes "Get all available coupons"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Admin Authentication Token'
    response :ok
    response :unauthorized
  end

  def index; end

  swagger_api :destroy do
    summary 'Deleting coupon by admin'
    notes "Delete a coupon"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Admin Authentication Token'
    param :path, :id, :integer, :required, 'Coupon ID'
    response :ok
    response :unauthorized
    response :unprocessable_entity
    response :not_found
  end

  def destroy
    return render json: { error: 'an error occured, please try again later' }, status: :unprocessable_entity unless @coupon.destroy
  end

  private

  def coupon_params
    params.require(:coupon).permit(:percentage, :starts_at, :ends_at)
  end

  def check_dates
    return render json: { error: 'end date can not be before start date' }, status: :unprocessable_entity if params[:coupon][:ends_at] < params[:coupon][:starts_at]
  end
end
