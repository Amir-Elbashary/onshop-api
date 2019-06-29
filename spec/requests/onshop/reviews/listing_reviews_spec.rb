require 'rails_helper'

RSpec.describe 'Listing product reviews', type: :request do
  before do
    @app_token = create(:app_token)
    @user = create(:user)
    @headers = { 'X-APP-Token' => @app_token.token }
    @product = create(:product)
    @product_review = create(:review, user: @user, product: @product)
    @other_review = create(:review, user: @user)
  end

  describe 'when presenting user ID' do
    context 'if it\'s valid ID' do
      it 'should list this user reviews only' do
        params = { user_id: @user.id }

        get '/v1/onshop/reviews', headers: @headers, params: params
        response_body = JSON.parse(response.body)

        expect(response.code).to eq('200')
        expect(response_body.count).to eq(2)
      end
    end

    context 'if it\'s invalid ID' do
      it 'should return not found' do
        params = { user_id: 88 }

        get '/v1/onshop/reviews', headers: @headers, params: params

        expect(response.code).to eq('404')
      end
    end
  end

  describe 'when presenting product ID' do
    context 'if it\'s valid ID' do
      it 'should list this product reviews only' do
        params = { product_id: @product.id }

        get '/v1/onshop/reviews', headers: @headers, params: params
        response_body = JSON.parse(response.body)

        expect(response.code).to eq('200')
        expect(response_body.count).to eq(1)
      end
    end

    context 'if it\'s invalid ID' do
      it 'should return not found' do
        params = { product_id: 88 }

        get '/v1/onshop/reviews', headers: @headers, params: params

        expect(response.code).to eq('404')
      end
    end
  end

  context 'when no IDs being sent' do
    it 'should return error message' do
      get '/v1/onshop/reviews', headers: @headers

      expect(response.code).to eq('422')
    end
  end
end
