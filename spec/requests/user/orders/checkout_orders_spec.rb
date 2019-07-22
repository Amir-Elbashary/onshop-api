require 'rails_helper'

RSpec.describe 'Checkout order', type: :request do
  before do
    @app_token = create(:app_token)
    @user = create(:user)
    @cart = create(:cart, user: @user, status: 0)
    @variant1 = create(:variant, quantity: 2, price: 100)
    @variant2 = create(:variant, quantity: 1, price: 200)
    @item1 = create(:item, cart: @cart, variant: @variant1, quantity: @variant1.quantity)
    @item2 = create(:item, cart: @cart, variant: @variant2, quantity: @variant2.quantity)
    @order = create(:order, cart: @cart, user: @user)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @user.authentication_token }
  end

  describe 'while presenting valid order ID' do
    context 'if transaction was successful' do
      it 'should checkout the order and deactivate the cart' do
        params = { success: 'true' }
        expect(Cart.first.state).to eq('active')

        post "/v1/user/orders/#{@order.id}/checkout", headers: @headers, params: params

        expect(response.code).to eq('200')
        expect(Cart.first.state).to eq('inactive')
        expect(@user.carts.active.any?).to eq(false)
      end
    end

    context 'if transaction failed' do
      it 'should not checkout the order and cart stays active' do
        params = { success: 'false' }
        expect(Cart.first.state).to eq('active')

        post "/v1/user/orders/#{@order.id}/checkout", headers: @headers, params: params

        expect(response.code).to eq('422')
        expect(Cart.first.state).to eq('active')
        expect(@user.carts.active.any?).to eq(true)
      end
    end

    context 'if no action taken' do
      it 'should ask for success param' do
        params = { success: '' }
        expect(Cart.first.state).to eq('active')

        post "/v1/user/orders/#{@order.id}/checkout", headers: @headers, params: params

        expect(response.code).to eq('422')
        expect(Cart.first.state).to eq('active')
        expect(@user.carts.active.any?).to eq(true)
      end
    end
  end

  context 'while presenting other user order ID' do
    it 'should return unauthorized' do
      user = create(:user)
      cart = create(:cart, user: user)
      variant1 = create(:variant, quantity: 2, price: 100)
      variant2 = create(:variant, quantity: 1, price: 200)
      item1 = create(:item, cart: cart, variant: variant1, quantity: variant1.quantity)
      item2 = create(:item, cart: cart, variant: variant2, quantity: variant2.quantity)
      order = create(:order, cart: cart, user: user)

      post "/v1/user/orders/#{order.id}/checkout", headers: @headers

      expect(response.code).to eq('401')
    end
  end

  context 'while presenting invalid order ID' do
    it 'should return not found' do
      post "/v1/user/orders/8888/checkout", headers: @headers

      expect(response.code).to eq('404')
    end
  end
end
