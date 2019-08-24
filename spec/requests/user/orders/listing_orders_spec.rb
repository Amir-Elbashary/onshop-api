require 'rails_helper'

RSpec.describe 'Listing user orders', type: :request do
  before do
    @app_token = create(:app_token)
    @user = create(:user_with_logins)
    @cart = create(:cart, user: @user, status: 0)
    @variant1 = create(:variant, quantity: 2, price: 100)
    @variant2 = create(:variant, quantity: 1, price: 200)
    @item1 = create(:item, cart: @cart, variant: @variant1, quantity: @variant1.quantity)
    @item2 = create(:item, cart: @cart, variant: @variant2, quantity: @variant2.quantity)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @user.logins.first.token }
  end
  
  describe 'when presenting valid user token' do
    context 'when order has no coupon code' do
      it 'should return all his orders with price = total price' do
        @order = create(:order, cart: @cart, user: @user)

        get "/v1/user/users/orders", headers: @headers
        response_body = JSON.parse(response.body)

        expect(response.code).to eq('200')
        expect(response_body.size).to eq(1)
        expect(response_body[0]['id']).to eq(@order.id)
        expect(response_body[0]['price'].to_d).to eq(@order.total_price)
      end
    end

    context 'when order has invalid coupon code' do
      it 'should return all his orders with price = total price' do
        @coupon = create(:coupon, starts_at: Time.zone.now - 2.days, ends_at: Time.zone.now - 1.days)
        @order = create(:order, cart: @cart, user: @user, coupon_code: @coupon.code)

        get "/v1/user/users/orders", headers: @headers
        response_body = JSON.parse(response.body)

        expect(response.code).to eq('200')
        expect(response_body.size).to eq(1)
        expect(response_body[0]['id']).to eq(@order.id)
        expect(response_body[0]['price'].to_d).to eq(@order.total_price)
      end
    end

    context 'when order has valid coupon code' do
      it 'should return all his orders with price < total price' do
        @coupon = create(:coupon)
        @order = create(:order, cart: @cart, user: @user, coupon_code: @coupon.code)

        get "/v1/user/users/orders", headers: @headers
        response_body = JSON.parse(response.body)

        expect(response.code).to eq('200')
        expect(response_body.size).to eq(1)
        expect(response_body[0]['id']).to eq(@order.id)
        expect(response_body[0]['price'].to_d).not_to eq(@order.total_price)
      end
    end
  end

  context 'when presenting invalid user token' do
    it 'should return unauthorized' do
      headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => 'invalid token' }

      get "/v1/user/users/orders", headers: headers

      expect(response.code).to eq('401')
    end
  end
end
