require 'rails_helper'

RSpec.describe 'Updating cart items (Change quantity)', type: :request do
  before do
    @app_token = create(:app_token)
    @user = create(:user_with_logins)
    @cart = create(:cart, user: @user)
    @variant = create(:variant, quantity: 2)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @user.logins.first.token }
  end

  context 'when updating variant with different quantity within stock range' do
    it 'should increase that variant quantity if stock has enough quantity' do
      @item = create(:item, cart: @cart, variant: @variant, quantity: 1)

      params = { 'item[variant_id]' => @variant.id,
                 'item[quantity]' => 2 }

      put "/v1/user/carts/#{@cart.id}/items/#{@item.id}", headers: @headers, params: params

      expect(response.code).to eq('200')
      expect(Cart.first.items.first.quantity).to eq(2)
    end
  end

  context 'when updating variant with different quantity which is more than stock' do
    it 'should not increase that variant quantity' do
      @item = create(:item, cart: @cart, variant: @variant, quantity: 1)

      params = { 'item[variant_id]' => @variant.id,
                 'item[quantity]' => 4 }

      put "/v1/user/carts/#{@cart.id}/items/#{@item.id}", headers: @headers, params: params
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('422')
      expect(response_body['message']).to eq("this variant has only #{@variant.quantity} in stock")
      expect(Cart.first.items.first.quantity).to eq(1)
    end
  end

  context 'when updating item while cart is locked' do
    it 'should ask for order canceling first' do
      @item = create(:item, cart: @cart, variant: @variant, quantity: 1)

      expect(Cart.first.items.first.quantity).to eq(1)

      @cart.locked!

      params = { 'item[variant_id]' => @variant.id,
                 'item[quantity]' => 2 }

      put "/v1/user/carts/#{@cart.id}/items/#{@item.id}", headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Cart.first.items.first.quantity).to eq(1)
    end
  end
end
