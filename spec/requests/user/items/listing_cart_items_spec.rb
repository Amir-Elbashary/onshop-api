require 'rails_helper'

RSpec.describe 'Listing cart items', type: :request do
  before do
    @app_token = create(:app_token)
    @user = create(:user_with_logins)
    @cart = create(:cart, user: @user)
    @item1 = create(:item, cart: @cart)
    @item2 = create(:item, cart: @cart)
    @other_user = create(:user)
    @others_cart = create(:cart, user: @other_user)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @user.logins.first.token }
  end
  
  context 'when presenting valid cart ID' do
    it 'should return all cart items' do
      get "/v1/user/carts/#{@cart.id}/items", headers: @headers
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body.size).to eq(2)
    end
  end

  context 'when presenting other user cart ID' do
    it 'should return unauthorized' do
      get "/v1/user/carts/#{@others_cart.id}/items", headers: @headers
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('401')
      expect(response_body['message']).to eq('you can only access this user\'s own carts')
    end
  end

  context 'when presenting invalid cart ID' do
    it 'should return not found' do
      get "/v1/user/carts/88/items", headers: @headers

      expect(response.code).to eq('404')
    end
  end
end
