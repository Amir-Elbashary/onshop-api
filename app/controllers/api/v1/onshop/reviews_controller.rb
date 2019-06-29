class Api::V1::Onshop::ReviewsController < Api::V1::Onshop::BaseOnshopController
  load_and_authorize_resource except: %i[index show]
  skip_authorization_check only: %i[index show]
  skip_load_resource only: %i[index show]
  before_action :set_user, only: %i[index]
  before_action :set_product, only: %i[index]
  before_action :set_reviews, only: %i[index]
  before_action :set_review, only: :show

  swagger_controller :reviews, 'OnShop'

  swagger_api :index do
    summary 'Listing product reviews'
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'User Authentication Token'
    param :query, :user_id, :integer, :optional, 'User ID'
    param :query, :product_id, :integer, :optional, 'Product ID'
    param :query, :page, :integer, :optional, 'Page Number'
    response :ok
    response :unauthorized
    response :unprocessable_entity
    response :not_found
  end

  def index
    return render json: { message: 'either user_id or product_id is required' }, status: :unprocessable_entity if params[:user_id].blank? && params[:product_id].blank?
    render json: @reviews, status: :ok
  end

  swagger_api :show do
    summary 'Listing product reviews'
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :path, :id, :integer, :required, 'Review ID'
    response :ok
    response :not_found
  end

  def show
    render json: @review, status: :ok
  end

  private

  def set_user
    @user = User.find(params[:user_id]) if params[:user_id]
  end

  def set_product
    @product = Product.find(params[:product_id]) if params[:product_id]
  end

  def set_review
    @review = Review.find(params[:id])
  end

  def set_reviews
    @reviews = if @user && @product
                 Review.where(user: @user, product: @product)
               elsif @user
                 @user.reviews.page(params[:page]).per_page(32)
               elsif @product
                 @product.reviews.page(params[:page]).per_page(32)
               end
  end
end
