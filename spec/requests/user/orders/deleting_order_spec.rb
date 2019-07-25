require 'rails_helper'

RSpec.describe 'Deleting/Canceling order', type: :request do
  before do
    @app_token = create(:app_token)
    @user = create(:user_with_logins)
    @cart = create(:cart, user: @user, status: 0)
    @variant1 = create(:variant, quantity: 2, price: 100)
    @variant2 = create(:variant, quantity: 1, price: 200)
    @item1 = create(:item, cart: @cart, variant: @variant1, quantity: @variant1.quantity)
    @item2 = create(:item, cart: @cart, variant: @variant2, quantity: @variant2.quantity)
    @order = create(:order, cart: @cart, user: @user)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @user.logins.first.token }
  end

  context 'while presenting valid ID' do
    it 'should cancel the order and unlock the cart' do
      expect(Order.count).to eq(1)
      expect(Cart.first.status).to eq('locked')

      delete "/v1/user/orders/#{@order.id}", headers: @headers

      expect(response.code).to eq('200')
      expect(Order.count).to eq(0)
      expect(Cart.first.status).to eq('unlocked')
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

      delete "/v1/user/orders/#{order.id}", headers: @headers

      expect(response.code).to eq('401')
    end
  end

  context 'while presenting invalid ID' do
    it 'should return not found' do
      delete "/v1/user/orders/8888", headers: @headers

      expect(response.code).to eq('404')
    end
  end
end
