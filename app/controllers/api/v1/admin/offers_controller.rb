class Api::V1::Admin::OffersController < Api::V1::Admin::BaseAdminController
  load_and_authorize_resource
  skip_load_resource
  before_action :check_dates, only: :create
  before_action :set_categories, except: :index

  swagger_controller :offers, 'Admin'

  swagger_api :create do
    summary 'Creating offer by admin'
    notes "Create an offer"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Admin Authentication Token'
    param :form, 'offer[category_ids]', :array, :required, 'Category IDs'
    param :form, 'offer[percentage]', :integer, :required, 'Percantage 0~100'
    param :form, 'offer[starts_at]', :datetime, :required, 'Offer start date'
    param :form, 'offer[ends_at]', :datetime, :required, 'Offer end date'
    param :form, 'offer[force]', :string, :required, 'true or false'
    param :query, :loc, :string, 'Locale'
    response :ok
    response :unauthorized
    response :unprocessable_entity
  end

  def create
    unless ['true', 'false'].include?(params[:offer][:force].downcase)
      return render json: { message: 'force params must be "true" or "false"' }, status: :unprocessable_entity
    end

    if params[:offer][:force] == 'false'
      return render json: { message: 'a category already have an offer', category_id: @existing_offer_category.id, category_name: @existing_offer_category.name }, status: :unprocessable_entity if existing_offers?(@categories)
    end

    @offers = []

    @categories.each do |category|
      category.offer&.destroy if params[:offer][:force] == 'true'

      offer = Offer.new(offer_params)
      offer.category = category
      return render json: { errors: offer.errors.full_messages }, status: :unprocessable_entity unless offer.save
      @offers << offer
    end
  end

  swagger_api :index do
    summary 'Get all offers'
    notes "Get all offers available"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Admin Authentication Token'
    param :query, :loc, :string, 'Locale'
    response :ok
    response :unauthorized
  end

  def index
    @offers = Offer.all
  end

  swagger_api :destroy do
    summary 'Deleting offer by admin'
    notes "Delete an offer"
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Admin Authentication Token'
    param :form, 'offer[category_ids]', :array, :required, 'Category IDs'
    response :ok
    response :unauthorized
    response :unprocessable_entity
    response :not_found
  end

  def destroy
    @categories.each do |category|
      return render json: { error: 'an error occured, please try again later' }, status: :unprocessable_entity unless category.offer.destroy
    end
  end

  private

  def offer_params
    params.require(:offer).permit(:percentage, :starts_at, :ends_at)
  end

  def set_categories
    @categories = Category.find(params[:offer][:category_ids])
  end

  def check_dates
    return render json: { error: 'end date can not be before start date' }, status: :unprocessable_entity if params[:offer][:ends_at] < params[:offer][:starts_at]
  end

  def existing_offers?(categories)
    categories.each do |category|
      if category.offer
        @existing_offer_category = category
        return true
      end
    end

    false
  end
end
