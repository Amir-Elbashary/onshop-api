require 'rails_helper'

RSpec.describe 'Getting user active cart', type: :request do
  before do
    @app_token = create(:app_token)
    @user = create(:user)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @user.authentication_token }
  end

  context 'when there is an active cart' do
    it 'should return this cart' do
      @active_cart = create(:cart, user: @user)
      @inactive_cart = create(:cart, user: @user, state: 0)
      get '/v1/user/carts/active_cart', headers: @headers
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body['id']).to eq(@active_cart.id)
    end
  end

  context 'when there is no active carts' do
    it 'should create new active cart' do
      @inactive_cart1 = create(:cart, user: @user, state: 0)
      @inactive_cart2 = create(:cart, user: @user, state: 0)
      get '/v1/user/carts/active_cart', headers: @headers
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body['id']).to_not eq(nil)
    end
  end
end
