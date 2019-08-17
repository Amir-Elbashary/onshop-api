require 'rails_helper'

RSpec.describe 'Confirming order', type: :request do
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
    it 'should confirm this order with valid status' do
      params = { 'order[status]' => 'paid' }

      expect(@order.status).to eq('pending')

      post "/v1/admin/orders/#{@order.id}/confirm", headers: @headers, params: params
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body['id']).to eq(@order.id)
      expect(Order.first.status).to eq('paid')
      expect(response_body['status']).to eq('paid')
    end

    it 'should not confirm this order with invalid status' do
      params = { 'order[status]' => 'still' }

      expect(@order.status).to eq('pending')

      post "/v1/admin/orders/#{@order.id}/confirm", headers: @headers, params: params
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('422')
      expect(Order.first.status).to eq('pending')
    end
  end

  context 'when presenting invalid order ID' do
    it 'should return not found' do
      post "/v1/admin/orders/8888/confirm", headers: @headers

      expect(response.code).to eq('404')
    end
  end
end
