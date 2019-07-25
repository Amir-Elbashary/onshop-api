require 'rails_helper'

RSpec.describe 'Attempting to access an API as an Admin', type: :request do
  before do
    @app_token = create(:app_token)
    @admin = create(:admin)
    token = JWT.encode({ email: @admin.email, exp: -80 }, ENV['SECRET_KEY_BASE'], 'HS256')
    @login = create(:login, admin: @admin, token: token)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @admin.logins.first.token }
  end

  context 'with expired token' do
    it 'should be asked to relogin' do
      params = { 'admin[first_name]' => 'New', 'admin[last_name]' => 'name' }

      put "/v1/admin/admins/#{@admin.id}", headers: @headers, params: params

      response_body = JSON.parse(response.body)

      expect(response.code).to eq('401')
      expect(Admin.first.full_name).to eq(@admin.full_name)
      expect(response_body['message']).to eq('session expired, please relogin')
    end
  end
end
