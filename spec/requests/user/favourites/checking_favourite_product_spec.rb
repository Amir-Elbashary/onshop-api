require 'rails_helper'

RSpec.describe 'Checking user favourite products', type: :request do
  before do
    @app_token = create(:app_token)
    @user = create(:user_with_logins)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @user.logins.first.token }
    @product1 = create(:product)
    @product2 = create(:product)
    Favourite.create(user: @user, favourited: @product1)
  end

  context 'when providing valid user token' do
    it 'should return "true" if this product is in his favourites' do
      expect(@user.favourite_products.count).to eq(1)

      get "/v1/user/products/#{@product1.id}/is_favourite", headers: @headers
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body['favourite']).to eq(true)
      expect(response_body['product']['id']).to eq(@product1.id)
    end

    it 'should return "false" if this product is not in his favourites' do
      expect(@user.favourite_products.count).to eq(1)

      get "/v1/user/products/#{@product2.id}/is_favourite", headers: @headers
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body['favourite']).to eq(false)
      expect(response_body['product']['id']).to eq(@product2.id)
    end
  end


  context 'when providing invalid product ID' do
    it 'should return not found' do
      get "/v1/user/products/8888/is_favourite", headers: @headers

      expect(response.code).to eq('404')
    end
  end

  context 'when providing invalid user token' do
    it 'should return unauthorized access' do
      headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => 'invalid token' }

      get "/v1/user/products/#{@product1.id}/is_favourite", headers: headers

      expect(response.code).to eq('401')
    end
  end
end
