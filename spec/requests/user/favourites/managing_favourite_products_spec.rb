require 'rails_helper'

RSpec.describe 'Managing favourite products by user', type: :request do
  before do
    @app_token = create(:app_token)
    @user = create(:user_with_logins)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @user.logins.first.token }
    @product1 = create(:product)
    @product2 = create(:product)
  end

  context 'when product isn\'t on list' do
    it 'should add the product to user favourites' do
      expect(@user.favourite_products.count).to eq(0)

      post "/v1/user/products/#{@product1.id}/favourite_product", headers: @headers
      expect(@user.favourite_products.count).to eq(1)

      post "/v1/user/products/#{@product2.id}/favourite_product", headers: @headers
      expect(@user.favourite_products.count).to eq(2)
    end
  end

  context 'when product already on list' do
    it 'should remove the product from user favourites' do
      Favourite.create(user: @user, favourited: @product1)
      Favourite.create(user: @user, favourited: @product2)

      expect(@user.favourite_products.count).to eq(2)

      post "/v1/user/products/#{@product1.id}/favourite_product", headers: @headers
      expect(@user.favourite_products.count).to eq(1)

      post "/v1/user/products/#{@product2.id}/favourite_product", headers: @headers
      expect(@user.favourite_products.count).to eq(0)
    end
  end

  context 'when providing invalid product ID' do
    it 'should return not found' do
      expect(@user.favourite_products.count).to eq(0)

      post "/v1/user/products/88/favourite_product", headers: @headers
      expect(response.code).to eq('404')
    end
  end
end
