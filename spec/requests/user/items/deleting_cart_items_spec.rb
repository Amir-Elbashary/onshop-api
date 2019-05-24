require 'rails_helper'

RSpec.describe 'Deleting item from cart', type: :request do
  before do
    @app_token = create(:app_token)
    @user = create(:user)
    @cart = create(:cart, user: @user)
    @item = create(:item, cart: @cart)
    @other_item = create(:item)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @user.authentication_token }
  end
  
  context 'while providing item ID which belongs to the same cart' do
    it 'should delete that item' do
      delete "/v1/user/carts/#{@cart.id}/items/#{@item.id}", headers: @headers

      expect(response.code).to eq('200')
      expect(@cart.items.count).to eq(0)
    end
  end

  context 'while providing item ID which does not belong to the same cart' do
    it 'should not delete that item' do
      delete "/v1/user/carts/#{@cart.id}/items/#{@other_item.id}", headers: @headers

      expect(response.code).to eq('422')
      expect(@cart.items.count).to eq(1)
    end
  end

  context 'while providing invalid ID' do
    it 'should respond with not found if cart ID is invalid' do
      delete "/v1/user/carts/88/items/#{@other_item.id}", headers: @headers

      expect(response.code).to eq('404')
      expect(@cart.items.count).to eq(1)
    end

    it 'should respond with not found if items ID is invalid' do
      delete "/v1/user/carts/#{@cart.id}/items/88", headers: @headers

      expect(response.code).to eq('404')
      expect(@cart.items.count).to eq(1)
    end
  end
end
