require 'rails_helper'

RSpec.describe 'Updating Admin info', type: :request do
  before do
    @app_token = create(:app_token)
    @admin = create(:admin)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @admin.authentication_token }
  end

  context 'with valid data' do
    it 'should update admin info' do
      params = { 'admin[first_name]' => 'New', 'admin[last_name]' => 'name' }

      put "/v1/admin/admins/#{@admin.id}", headers: @headers, params: params

      expect(response.code).to eq('200')
      expect(Admin.first.full_name).to eq('New name')
    end
  end

  context 'with invalid data' do
    it 'should not update admin info' do
      params = { 'admin[first_name]' => '', 'admin[last_name]' => '' }

      put "/v1/admin/admins/#{@admin.id}", headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Admin.first.full_name).to eq(@admin.full_name)
    end
  end
end
