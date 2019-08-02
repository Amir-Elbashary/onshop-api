require 'rails_helper'

RSpec.describe 'Clearing cart items', type: :request do
  before do
    @app_token = create(:app_token)
    @user = create(:user_with_logins)
    @cart = create(:cart, user: @user)
    @item1 = create(:item, cart: @cart)
    @item2 = create(:item, cart: @cart)
    @others_cart = create(:cart)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @user.logins.first.token }
  end
  
  context 'while providing cart ID which belongs to the same user' do
    it 'should clear this cart' do
      post "/v1/user/carts/#{@cart.id}/clear", headers: @headers

      expect(response.code).to eq('200')
      expect(@cart.items.count).to eq(0)
    end
  end

  context 'while providing cart ID which does not belong to the same user' do
    it 'should return unauthorized' do
      post "/v1/user/carts/#{@others_cart.id}/clear", headers: @headers

      expect(response.code).to eq('401')
      expect(@cart.items.count).to eq(2)
    end
  end

  context 'while providing invalid cart ID' do
    it 'should respond with not found' do
      post "/v1/user/carts/8888/clear", headers: @headers

      expect(response.code).to eq('404')
      expect(@cart.items.count).to eq(2)
    end
  end

  context 'when clearing locked cart' do
    it 'should ask for order canceling first' do
      @cart.locked!

      post "/v1/user/carts/#{@cart.id}/clear", headers: @headers

      expect(response.code).to eq('422')
      expect(@cart.items.count).to eq(2)
    end
  end
end
