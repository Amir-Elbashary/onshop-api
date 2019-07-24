require 'rails_helper'

RSpec.describe 'Listing user carts', type: :request do
  before do
    @app_token = create(:app_token)
    @user = create(:user_with_logins)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @user.logins.first.token }
    @cart1 = create(:cart, user: @user)
    @cart2 = create(:cart, user: @user)
  end
  
  context 'when presenting valid user token' do
    it 'should return all user cart' do
      get '/v1/user/carts', headers: @headers
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body.size).to eq(2)
    end
  end

  context 'when presenting invalid user token' do
    it 'should return unauthorized access' do
      headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => 'invalid token' }
      get '/v1/user/carts', headers: headers

      expect(response.code).to eq('401')
    end
  end
end
