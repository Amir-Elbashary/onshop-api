require 'rails_helper'

RSpec.describe 'Getting App Settings', type: :request do
  before do
    @app_token = create(:app_token)
    @admin = create(:admin)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @admin.authentication_token }
    AppSetting.create(name_en: 'My Shop')
  end

  context 'with valid admin token' do
    it 'should get app settings' do
      get "/v1/admin/app_settings", headers: @headers

      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body['name_en']).to eq('My Shop')
    end
  end

  context 'with invalid admin token' do
    it 'should not get app settings' do
      get "/v1/admin/app_settings", headers: { 'X-User-Token' => 'invalid token' }

      expect(response.code).to eq('401')
    end
  end
end
