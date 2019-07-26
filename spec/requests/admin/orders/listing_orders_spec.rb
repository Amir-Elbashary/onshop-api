require 'rails_helper'

RSpec.describe 'Listing orders', type: :request do
  before do
    @app_token = create(:app_token)
    @admin = create(:admin_with_logins)
    @user = create(:user)
    @cart = create(:cart, user: @user, status: 0)
    @variant1 = create(:variant, quantity: 2, price: 100)
    @variant2 = create(:variant, quantity: 1, price: 200)
    @item1 = create(:item, cart: @cart, variant: @variant1, quantity: @variant1.quantity)
    @item2 = create(:item, cart: @cart, variant: @variant2, quantity: @variant2.quantity)
    @order = create(:order, cart: @cart, user: @user)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @admin.logins.first.token }
  end
  
  context 'when presenting valid admin token' do
    it 'should return all orders' do
      get "/v1/admin/orders", headers: @headers
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body.size).to eq(1)
      expect(response_body[0]['id']).to eq(@order.id)
    end
  end

  context 'when presenting invalid admin token' do
    it 'should return unauthorized' do
      headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => 'invalid token' }

      get "/v1/admin/orders", headers: headers

      expect(response.code).to eq('401')
    end
  end
end
