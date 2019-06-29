require 'rails_helper'

RSpec.describe 'Deleting product', type: :request do
  before do
    @app_token = create(:app_token)
    @user = create(:user)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @user.authentication_token }
    @product_review = create(:review, user: @user)
    @others_product_review = create(:review)
  end

  context 'while providing review ID which belongs to the same user' do
    it 'should delete that review' do
      delete "/v1/user/reviews/#{@product_review.id}", headers: @headers

      expect(response.code).to eq('200')
      expect(Review.count).to eq(1)
    end
  end

  context 'while providing review ID which does not belong to the same user' do
    it 'should not delete that review' do
      delete "/v1/user/reviews/#{@others_product_review.id}", headers: @headers

      expect(response.code).to eq('422')
      expect(Review.count).to eq(2)
    end
  end

  context 'while providing invalid ID' do
    it 'should respond with not found' do
      delete "/v1/user/reviews/88", headers: @headers

      expect(response.code).to eq('404')
      expect(Review.count).to eq(2)
    end
  end
end
