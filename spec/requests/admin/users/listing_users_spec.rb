require 'rails_helper'

RSpec.describe 'Listing users by admin', type: :request do
  before do
    @app_token = create(:app_token)
    @admin = create(:admin)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @admin.authentication_token }
  end

  context 'if there are any users' do
    it 'should list all users on the system' do
      @user1 = create(:user)
      @user2 = create(:user)

      get '/v1/admin/users', headers: @headers
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body.count).to eq(2)
    end
  end

  context 'if there are no users' do
    it 'should return no merchants' do
      get '/v1/admin/users', headers: @headers

      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body).to eq([])
    end
  end
end
