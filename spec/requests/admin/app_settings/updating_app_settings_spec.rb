require 'rails_helper'

RSpec.describe 'Updating App Settings', type: :request do
  before do
    @app_token = create(:app_token)
    @admin = create(:admin)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @admin.authentication_token }
    AppSetting.create(name_en: 'My Shop')
  end

  context 'with valid data' do
    it 'should update app settings' do
      params = { 'app_setting[name_en]' => 'OnShop', 'app_setting[description]' => 'Awesome Shop' }

      put "/v1/admin/app_settings/id", headers: @headers, params: params

      expect(response.code).to eq('200')
      expect(AppSetting.first.name).to eq('OnShop')
    end
  end

  context 'with invalid data' do
    it 'should not update app settings' do
      params = { 'app_setting[name_en]' => '' }

      put "/v1/admin/app_settings/id", headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(AppSetting.first.name_en).to eq('My Shop')
    end
  end
end
