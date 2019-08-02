require 'rails_helper'

RSpec.describe 'Getting user favourite products', type: :request do
  before do
    @app_token = create(:app_token)
    @user = create(:user_with_logins)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @user.logins.first.token }
    @product1 = create(:product)
    @product1_variant1 = create(:variant, product: @product1)
    @product1_variant2 = create(:variant, product: @product1)
    @product2 = create(:product)
    Favourite.create(user: @user, favourited: @product1)
    Favourite.create(user: @user, favourited: @product2)
  end

  context 'when providing valid user token' do
    it 'should return this user favourite products' do
      expect(@user.favourite_products.count).to eq(2)

      get "/v1/user/users/favourite_products", headers: @headers
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body.count).to eq(2)
      expect(response_body[0]['variants'].count).to eq(2)
      expect(response_body[0]['variants'][0]['id']).to eq(@product1_variant1.id)
      expect(response_body[0]['variants'][1]['id']).to eq(@product1_variant2.id)
    end
  end

  context 'when providing invalid user token' do
    it 'should return unauthorized access' do
      headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => 'invalid token' }

      expect(@user.favourite_products.count).to eq(2)

      get "/v1/user/users/favourite_products", headers: headers
      expect(response.code).to eq('401')
    end
  end
end
