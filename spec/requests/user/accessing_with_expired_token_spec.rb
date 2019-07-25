require 'rails_helper'

RSpec.describe 'Attempting to access an API as a user', type: :request do
  before do
    @app_token = create(:app_token)
    @user = create(:user)
    token = JWT.encode({ email: @user.email, exp: -80 }, ENV['SECRET_KEY_BASE'], 'HS256')
    @login = create(:login, user: @user, token: token)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @user.logins.first.token }
  end

  context 'with expired token' do
    it 'should be asked to relogin' do
      get "/v1/user/users/id", headers: @headers

      response_body = JSON.parse(response.body)

      expect(response.code).to eq('401')
      expect(response_body['message']).to eq('session expired, please relogin')
    end
  end
end
