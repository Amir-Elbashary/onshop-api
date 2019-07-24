require 'rails_helper'

RSpec.describe 'Getting user profile info', type: :request do
  before do
    @app_token = create(:app_token)
    @user = create(:user_with_logins)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @user.logins.first.token }
  end

  context 'with valid token' do
    it 'should get user profile info' do
      get "/v1/user/users/id", headers: @headers
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body['first_name']).to eq(@user.first_name)
    end
  end

  context 'with invalid token' do
    it 'should not get user profile info' do
      get "/v1/user/users/id", headers: { 'X-User-Token' => 'invalid token' }

      expect(response.code).to eq('401')
    end
  end
end
