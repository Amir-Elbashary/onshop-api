require 'rails_helper'

RSpec.describe 'Showing user carts', type: :request do
  before do
    @app_token = create(:app_token)
    @user = create(:user)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @user.authentication_token }
    @cart1 = create(:cart, user: @user)
    @cart2 = create(:cart, user: @user)
    @others_cart = create(:cart)
  end

  context 'when presenting valid cart ID' do
    it 'should return this cart' do
      get "/v1/user/carts/#{@cart1.id}", headers: @headers
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body['id']).to eq(@cart1.id)
    end
  end

  context 'when presenting invalid cart ID' do
    it 'should return not found' do
      get "/v1/user/carts/88", headers: @headers

      expect(response.code).to eq('404')
    end
  end

  context 'when presenting cart ID which does not belong to this user' do
    it 'should return unauthorized' do
      get "/v1/user/carts/#{@others_cart.id}", headers: @headers
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('401')
      expect(response_body['message']).to eq('not allowed, this cart does not belong to this user')
    end
  end
end
