require 'rails_helper'

RSpec.describe 'Changing AppToken by admin', type: :request do
  before do
    @app_token = create(:app_token)
    @admin = create(:admin_with_logins)
  end

  context 'with valid credentials' do
    it 'should be able to generate new token' do
      headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @admin.logins.first.token }

      post '/v1/admin/app_tokens.json', headers: headers

      expect(response.code).to eq('201')
      expect(AppToken.first.token).not_to eq(@app_token.token)
    end

    it 'should use the new generated token' do
      # Generating new app token
      headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @admin.logins.first.token }

      post '/v1/admin/app_tokens.json', headers: headers

      # logging in using the old token
      headers = { 'X-APP-Token' => @app_token.token }
      params = { 'admin[email]' => @admin.email, 'admin[password]' => @admin.password }

      post '/v1/admin/sessions.json', headers: headers, params: params

      expect(response.code).to eq('401')
    end
  end

  context 'with invalid credentials' do
    it 'should not be able to generate new token' do
      headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => 'wrong token' }

      post '/v1/admin/app_tokens.json', headers: headers

      expect(response.code).to eq('401')
      expect(AppToken.first.token).to eq(@app_token.token)
    end
  end
end
