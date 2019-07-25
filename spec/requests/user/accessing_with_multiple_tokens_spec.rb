require 'rails_helper'

RSpec.describe 'Attempting to access an API as a user', type: :request do
  before do
    @app_token = create(:app_token)
    @user = create(:user)
    token = JWT.encode({ email: @user.email }, ENV['SECRET_KEY_BASE'], 'HS256')
    token2 = JWT.encode({ email: @user.email }, ENV['SECRET_KEY_BASE'], 'HS256')
    @login = create(:login, user: @user, token: token)
    @login2 = create(:login, user: @user, token: token2)
  end

  context 'with multiple valid tokens' do
    it 'should get valid response' do
      headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @login.token }
      get "/v1/user/users/id", headers: headers

      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')

      headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @login2.token }
      get "/v1/user/users/id", headers: headers

      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
    end
  end
end
