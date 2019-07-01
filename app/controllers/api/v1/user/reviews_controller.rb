class Api::V1::User::ReviewsController < Api::V1::User::BaseUserController
  rescue_from ActiveRecord::RecordNotUnique, with: :already_exists
  load_and_authorize_resource
  skip_load_resource only: :index
  before_action :require_same_user, only: %i[update destroy]

  swagger_controller :reviews, 'User'

  swagger_api :create do
    summary 'Creating product reviews'
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'User Authentication Token'
    param :form, 'review[user_id]', :integer, :required, 'User ID'
    param :form, 'review[product_id]', :integer, :required, 'Product ID'
    param :form, 'review[review]', :text, :optional, 'Review text'
    param :form, 'review[rating]', :integer, :optional, 'Rating 0-5'
    response :created
    response :unauthorized
    response :not_found
  end

  def create
    check_user_and_product

    if @review.save
      render json: @review, status: :created
    else
      render json: @review.errors.full_messages, status: :unprocessable_entity
    end
  end

  swagger_api :update do
    summary 'Updating product reviews'
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'User Authentication Token'
    param :form, 'review[user_id]', :integer, :required, 'User ID'
    param :form, 'review[product_id]', :integer, :required, 'Product ID'
    param :form, 'review[review]', :text, :optional, 'Review text'
    param :form, 'review[rating]', :integer, :optional, 'Rating 0-5'
    response :ok
    response :unauthorized
    response :not_found
  end

  def update
    if @review.update(review_params)
      render json: @review, status: :ok
    else
      render json: { message: @review.errors.full_messages }, status: :unprocessable_entity
    end
  end

  swagger_api :index do
    summary 'Listing user reviews'
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'User Authentication Token'
    param :query, :page, :integer, :optional, 'Page Number'
    response :ok
    response :unauthorized
    response :unprocessable_entity
    response :not_found
  end

  def index
    if current_user.reviews.any?
      render json: current_user.reviews.page(params[:page]).per_page(32), status: :ok
    else
      render json: { message: 'no reviews yer' }, status: :ok
    end
  end

  swagger_api :destroy do
    summary 'Deleting product reviews'
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'User Authentication Token'
    param :path, :id, :integer, :required, 'Review ID'
    response :ok
    response :unauthorized
    response :unprocessable_entity
    response :not_found
  end

  def destroy
    render json: { message: 'review deleted' }, status: :ok if @review.destroy
  end

  private

  def review_params
    params.require(:review).permit(:user_id, :product_id, :review, :rating)
  end

  def require_same_user
    return render json: { message: 'you may only delete your own reviews' }, status: :unprocessable_entity if @review.user != current_user
  end

  def check_user_and_product
    @user = User.find(params[:review][:user_id])
    @product = Product.find(params[:review][:product_id])

    return render json: { message: 'user or product not found' }, status: :not_found if @user.nil? || @product.nil?
  end

  def already_exists
    return render json: { message: 'user has already reviewed this product' }, status: :unprocessable_entity
  end
end
