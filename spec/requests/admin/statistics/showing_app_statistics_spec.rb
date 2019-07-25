require 'rails_helper'

RSpec.describe 'Getting current app statistics by an admin', type: :request do
  before do
    @app_token = create(:app_token)
    @admin = create(:admin_with_logins)
  end

  context 'with valid admin token' do
    it 'should show app statistics' do
      headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @admin.logins.first.token }
      get "/v1/admin/statistics/id", headers: headers

      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body.size).to eq(6)
    end
  end

  context 'with invalid admin token' do
    it 'should return unauthorized' do
      headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => 'invalid token' }
      get "/v1/admin/statistics/id", headers: headers

      expect(response.code).to eq('401')
    end
  end
end
