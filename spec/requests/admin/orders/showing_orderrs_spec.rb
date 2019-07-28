require 'rails_helper'

RSpec.describe 'Showing order', type: :request do
  before do
    @app_token = create(:app_token)
    @admin = create(:admin_with_logins)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @admin.logins.first.token }
    @user = create(:user)
    @cart = create(:cart, user: @user, status: 0)
    @variant1 = create(:variant, quantity: 2, price: 100)
    @variant2 = create(:variant, quantity: 1, price: 200)
    @item1 = create(:item, cart: @cart, variant: @variant1, quantity: @variant1.quantity)
    @item2 = create(:item, cart: @cart, variant: @variant2, quantity: @variant2.quantity)
    @order = create(:order, cart: @cart, user: @user)
  end

  context 'when presenting valid order ID' do
    it 'should show this order' do
      get "/v1/admin/orders/#{@order.id}", headers: @headers
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body['id']).to eq(@order.id)
    end
  end

  context 'when presenting invalid order ID' do
    it 'should return not found' do
      get "/v1/admin/orders/8888", headers: @headers

      expect(response.code).to eq('404')
    end
  end
end
