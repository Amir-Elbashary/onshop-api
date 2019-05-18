require 'rails_helper'

RSpec.describe 'Creating user by admin', type: :request do
  before do
    @app_token = create(:app_token)
    @admin = create(:admin)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @admin.authentication_token }
  end

  context 'with valid data' do
    it 'should create new user' do
      params = { 'user[email]' => 'user@onshop.com',
                 'user[password]' => '12345678',
                 'user[password_confirmation]' => '12345678',
                 'user[first_name]' => 'OnShop',
                 'user[last_name]' => 'User' }

      post '/v1/admin/users', headers: @headers, params: params

      expect(response.code).to eq('201')
      expect(User.first.email).to eq('user@onshop.com')
      expect(User.first.full_name).to eq('OnShop User')
    end
  end

  context 'with invalid data' do
    it 'should not create new user' do
      params = { 'user[email]' => 'user',
                 'user[password]' => '12345678',
                 'user[password_confirmation]' => '12345678',
                 'user[first_name]' => 'OnShop',
                 'user[last_name]' => 'User' }

      post '/v1/admin/users', headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(User.count).to eq(0)
    end
  end

  context 'with duplicated data' do
    it 'should not create new user' do
      @user = create(:user)

      params = { 'user[email]' => @user.email,
                 'user[password]' => '12345678',
                 'user[password_confirmation]' => '12345678',
                 'user[first_name]' => 'OnShop',
                 'user[last_name]' => 'User' }

      post '/v1/admin/users', headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(User.count).to eq(1)
    end
  end
end
