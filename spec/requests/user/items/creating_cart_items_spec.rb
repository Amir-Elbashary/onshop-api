require 'rails_helper'

RSpec.describe 'Creating cart items (Add item to cart)', type: :request do
  before do
    @app_token = create(:app_token)
    @user = create(:user_with_logins)
    @cart = create(:cart, user: @user)
    @variant1 = create(:variant, quantity: 2)
    @variant2 = create(:variant, quantity: 1)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @user.logins.first.token }
  end

  describe 'with valid data' do
    context 'if quantity is less than or equal to variant quantity' do
      it 'should add new item to cart including this variant' do
        params = { 'item[variant_id]' => @variant1.id,
                   'item[quantity]' => 2 }

        post "/v1/user/carts/#{@cart.id}/items", headers: @headers, params: params

        expect(response.code).to eq('200')
        expect(@cart.items.first.variant.product.name).to eq(@variant1.product.name)
        expect(Cart.first.items.count).to eq(1)

        params = { 'item[variant_id]' => @variant2.id,
                   'item[quantity]' => 1 }

        post "/v1/user/carts/#{@cart.id}/items", headers: @headers, params: params

        expect(response.code).to eq('200')
        expect(@cart.items.last.variant.product.name).to eq(@variant2.product.name)
        expect(Cart.first.items.count).to eq(2)
      end
    end

    context 'if quantity is more than variant quantity' do
      it 'should not add new item to cart' do
        params = { 'item[variant_id]' => @variant1.id,
                   'item[quantity]' => 4 }

        post "/v1/user/carts/#{@cart.id}/items", headers: @headers, params: params
        response_body = JSON.parse(response.body)

        expect(response.code).to eq('422')
        expect(response_body['message']).to eq("this variant has only #{@variant1.quantity} in stock")
        expect(Cart.first.items.count).to eq(0)
      end
    end

    context 'if other user\'s cart ID is presented' do
      it 'should return unauthorized access' do
        @other_user = create(:user)
        @others_cart = create(:cart, user: @other_user)

        params = { 'item[variant_id]' => @variant1.id,
                   'item[quantity]' => 4 }

        post "/v1/user/carts/#{@others_cart.id}/items", headers: @headers, params: params
        response_body = JSON.parse(response.body)

        expect(response.code).to eq('401')
        expect(response_body['message']).to eq('you can only access this user\'s own carts')
        expect(Cart.first.items.count).to eq(0)
      end
    end
  end

  describe 'with invalid data' do
    context 'when providing other user cart ID' do
      it 'should return unauthorized access' do
        @other_user = create(:user)
        @others_cart = create(:cart, user: @other_user)

        params = { 'item[variant_id]' => @variant1.id,
                   'item[quantity]' => 2 }

        post "/v1/user/carts/#{@others_cart.id}/items", headers: @headers, params: params
        response_body = JSON.parse(response.body)

        expect(response.code).to eq('401')
        expect(response_body['message']).to eq('you can only access this user\'s own carts')
        expect(Cart.first.items.count).to eq(0)
        expect(Cart.last.items.count).to eq(0)

        params = { 'item[variant_id]' => @variant2.id,
                   'item[quantity]' => 1 }

        post "/v1/user/carts/#{@cart.id}/items", headers: @headers, params: params

        expect(response.code).to eq('200')
        expect(@cart.items.last.variant.product.name).to eq(@variant2.product.name)
        expect(Cart.first.items.count).to eq(1)
      end
    end

    context 'when providing wrong cart ID' do
      it 'should return not found' do
        post "/v1/user/carts/88/items", headers: @headers

        expect(response.code).to eq('404')
      end
    end

    context 'when providing wrong variant ID' do
      it 'should return not found' do
        params = { 'item[variant_id]' => 88,
                   'item[quantity]' => 4 }

        post "/v1/user/carts/#{@cart.id}/items", headers: @headers, params: params

        expect(response.code).to eq('404')
      end
    end

    context 'when providing invalid quantity' do
      it 'should return not found' do
        params = { 'item[variant_id]' => @variant1.id,
                   'item[quantity]' => 'quantity' }

        post "/v1/user/carts/#{@cart.id}/items", headers: @headers, params: params

        expect(response.code).to eq('422')
      end
    end
  end

  context 'when adding same variant on cart' do
    it 'should make sure the variant is already added' do
      @item = create(:item, cart: @cart, variant: @variant1, quantity: 1)

      params = { 'item[variant_id]' => @variant1.id,
                 'item[quantity]' => 2 }

      post "/v1/user/carts/#{@cart.id}/items", headers: @headers, params: params

      expect(response.code).to eq('200')
      expect(Cart.first.items.count).to eq(1)
      expect(Cart.first.items.first.quantity).to eq(1)
    end
  end

  context 'when adding item while cart is locked' do
    it 'should ask for order canceling first' do
      params = { 'item[variant_id]' => @variant1.id,
                 'item[quantity]' => 2 }

      post "/v1/user/carts/#{@cart.id}/items", headers: @headers, params: params

      expect(response.code).to eq('200')
      expect(Cart.first.status).to eq('unlocked')
      expect(@cart.items.first.variant.product.name).to eq(@variant1.product.name)
      expect(Cart.first.items.count).to eq(1)

      @cart.locked!

      params = { 'item[variant_id]' => @variant2.id,
                 'item[quantity]' => 1 }

      post "/v1/user/carts/#{@cart.id}/items", headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Cart.first.status).to eq('locked')
      expect(@cart.items.last.variant.product.name).to eq(@variant1.product.name)
      expect(Cart.first.items.count).to eq(1)
    end
  end
end
