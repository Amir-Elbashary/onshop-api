require 'rails_helper'

RSpec.describe 'Updating user profile info', type: :request do
  before do
    @app_token = create(:app_token)
    @user = create(:user)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @user.authentication_token }
  end

  context 'with valid info' do
    it 'should update profile info' do
      params = { 'user[first_name]' => 'OnShop',
                 'user[last_name]' => 'User',
                 'user[shipping_address]' => 'My Address'
               }

      put "/v1/user/users/update_profile", headers: @headers, params: params

      expect(response.code).to eq('200')
      expect(User.first.full_name).to eq('OnShop User')
      expect(User.first.shipping_address).to eq('My Address')
    end
  end

  context 'with invalid info' do
    it 'should not update profile info' do
      params = { 'user[first_name]' => '',
                 'user[last_name]' => '',
                 'user[shipping_address]' => 'My Address'
               }

      put "/v1/user/users/update_profile", headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(User.first.full_name).to eq(@user.full_name)
      expect(User.first.shipping_address).to eq(nil)
    end
  end
end
