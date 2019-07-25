require 'rails_helper'

RSpec.describe 'Creating order', type: :request do
  before do
    @app_token = create(:app_token)
    @user = create(:user_with_logins)
    @cart = create(:cart, user: @user)
    @variant1 = create(:variant, quantity: 2, price: 100)
    @variant2 = create(:variant, quantity: 1, price: 200)
    @item1 = create(:item, cart: @cart, variant: @variant1, quantity: @variant1.quantity)
    @item2 = create(:item, cart: @cart, variant: @variant2, quantity: @variant2.quantity)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @user.logins.first.token }
  end

  describe 'while cart does not have an order' do
    context 'if cart contains at least one item' do
      it 'should create order for this cart and lock the cart' do
        params = { 'order[cart_id]' => @cart.id,
                   'order[user_id]' => @user.id }

        post '/v1/user/orders', headers: @headers, params: params

        expect(response.code).to eq('200')
        expect(Order.first.cart).to eq(@cart)
        expect(Order.first.user).to eq(@user)
        expect(Order.first.total_items).to eq(3)
        expect(Order.first.total_price).to eq(400)
        expect(Order.first.cart.status).to eq('locked')
      end
    end

    context 'if cart is empty' do
      it 'should not create order for this cart' do
        cart = create(:cart, user: @user)

        params = { 'order[cart_id]' => cart.id,
                   'order[user_id]' => @user.id }

        post '/v1/user/orders', headers: @headers, params: params

        expect(response.code).to eq('422')
        expect(Order.count).to eq(0)
        expect(cart.status).to eq('unlocked')
      end
    end
  end

  context 'if cart already has an order' do
    it 'should return order already exists' do
      order = create(:order, cart: @cart, user: @user)

      params = { 'order[cart_id]' => @cart.id,
                 'order[user_id]' => @user.id }

      post '/v1/user/orders', headers: @headers, params: params

      expect(response.code).to eq('422')
    end
  end

  context 'if cart does not belong to user' do
    it 'should return error' do
      cart = create(:cart)
      variant1 = create(:variant, quantity: 2, price: 100)
      variant2 = create(:variant, quantity: 1, price: 200)
      item1 = create(:item, cart: cart, variant: variant1, quantity: variant1.quantity)
      item2 = create(:item, cart: cart, variant: variant2, quantity: variant2.quantity)

      params = { 'order[cart_id]' => cart.id,
                 'order[user_id]' => @user.id }

      post '/v1/user/orders', headers: @headers, params: params

      expect(response.code).to eq('422')
    end
  end
end
