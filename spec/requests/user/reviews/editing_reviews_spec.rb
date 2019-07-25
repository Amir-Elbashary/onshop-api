require 'rails_helper'

RSpec.describe 'Editing product review by user', type: :request do
  before do
    @app_token = create(:app_token)
    @user = create(:user_with_logins)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @user.logins.first.token }
    @product_review = create(:review, user: @user)
    @others_product_review = create(:review)
  end

  context 'editing own product review with valid data' do
    it 'should update product review' do
      params = { 'review[review]' => 'Updated product review',
                 'review[rating]' => 4 }

      put "/v1/user/reviews/#{@product_review.id}", headers: @headers, params: params

      expect(response.code).to eq('200')
      expect(@user.reviews.first.review).to eq('Updated product review')
      expect(@user.reviews.first.rating).to eq(4)
    end
  end

  context 'editing own product review with invalid data' do
    it 'should not update product review' do
      params = { 'review[review]' => 'Updated product review',
                 'review[rating]' => -4 }

      put "/v1/user/reviews/#{@product_review.id}", headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(@user.reviews.first.review).to eq(@product_review.review)
    end
  end

  context 'attempting to edit others product review' do
    it 'should not allow to edit the product review' do
      params = { 'review[review]' => 'Updated product review',
                 'review[rating]' => 4 }

      put "/v1/user/reviews/#{@others_product_review.id}", headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Review.where.not(user: @user).first.review).to eq(@others_product_review.review)
    end
  end
end
