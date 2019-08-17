require 'rails_helper'

RSpec.describe 'Applying coupon code on an order', type: :request do
  before do
    @app_token = create(:app_token)
    @user = create(:user_with_logins)
    @other_user = create(:user_with_logins)
    @cart = create(:cart, user: @user, status: 0)
    @variant1 = create(:variant, quantity: 2, price: 100)
    @variant2 = create(:variant, quantity: 1, price: 200)
    @item1 = create(:item, cart: @cart, variant: @variant1, quantity: @variant1.quantity)
    @item2 = create(:item, cart: @cart, variant: @variant2, quantity: @variant2.quantity)
    @order = create(:order, cart: @cart, user: @user)
    @coupon = create(:coupon)
    @expired_coupon = create(:coupon, starts_at: (Time.zone.now - 2.days), ends_at: (Time.zone.now - 1.days))
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @user.logins.first.token }
  end

  describe 'with valid coupon code' do
    context 'if this order belongs to the same user' do
      it 'should add/update the coupon code if code is active' do
        params = { 'order[coupon_code]' => @coupon.code }

        post "/v1/user/orders/#{@order.id}/coupon", headers: @headers, params: params

        expect(response.code).to eq('200')
        expect(Order.first.coupon_code).to eq(@coupon.code)
      end

      it 'should not add/update the coupon code if code is expired' do
        params = { 'order[coupon_code]' => @expired_coupon.code }

        post "/v1/user/orders/#{@order.id}/coupon", headers: @headers, params: params

        expect(response.code).to eq('422')
        expect(Order.first.coupon_code).to eq(nil)
      end
    end

    context 'if this order does not belong to the same user' do
      it 'should return unauthorized' do
        headers = { 'X-APP-Token' => @app_token.token,
                    'X-User-Token' => @other_user.logins.first.token }
        params = { 'order[coupon_code]' => @coupon.code }

        post "/v1/user/orders/#{@order.id}/coupon", headers: headers, params: params

        expect(response.code).to eq('401')
        expect(Order.first.coupon_code).to eq(nil)
      end
    end
  end

  describe 'with invalid coupon code' do
    it 'should not add/update the coupon code' do
      params = { 'order[coupon_code]' => 'invalid-code' }

      post "/v1/user/orders/#{@order.id}/coupon", headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Order.first.coupon_code).to eq(nil)
    end
  end
end
