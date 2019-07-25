require 'rails_helper'

RSpec.describe 'Creating product review as user', type: :request do
  before do
    @app_token = create(:app_token)
    @user = create(:user_with_logins)
    @product = create(:product)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @user.logins.first.token }
  end

  context 'with valid data' do
    it 'should create a product review' do
      params = { 'review[user_id]' => @user.id,
                 'review[product_id]' => @product.id,
                 'review[review]' => 'New product review',
                 'review[rating]' => 5 }

      post '/v1/user/reviews', headers: @headers, params: params

      expect(@product.reviews.first.review).to eq('New product review')
      expect(@product.reviews.first.rating).to eq(5)
      expect(response.code).to eq('201')
      expect(Review.count).to eq(1)
    end
  end

  context 'with invalid data' do
    it 'should not create a product review' do
      params = { 'review[user_id]' => @user.id,
                 'review[product_id]' => @product.id,
                 'review[review]' => 'New product review',
                 'review[rating]' => -1 }

      post '/v1/user/reviews', headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Review.count).to eq(0)
    end
  end

  context 'with duplicated data' do
    it 'should not create a product' do
      @review = create(:review, user: @user, product: @product)

      params = { 'review[user_id]' => @user.id,
                 'review[product_id]' => @product.id,
                 'review[review]' => 'New product review',
                 'review[rating]' => 5 }

      post '/v1/user/reviews', headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Review.count).to eq(1)
    end
  end
end
