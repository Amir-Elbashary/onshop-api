require 'rails_helper'

RSpec.describe 'Updating user profile info', type: :request do
  before do
    @app_token = create(:app_token)
    @user = create(:user_with_logins, password: 'useruser', password_confirmation: 'useruser')
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @user.logins.first.token }
  end

  describe 'with valid info (with password)' do
    context 'if current password is invalid' do
      it 'should return wrong password' do
        params = { 'user[first_name]' => 'New OnShop',
                   'user[last_name]' => 'User',
                   'user[shipping_address]' => 'My Address',
                   'user[current_password]' => 'wrong password',
                   'user[password]' => 'newpassword',
                   'user[password_confirmation]' => 'newpassword'
                 }

        put "/v1/user/users/update_profile", headers: @headers, params: params

        expect(response.code).to eq('422')
        expect(User.first.full_name).to eq(@user.full_name)
        expect(User.first.shipping_address).to eq(nil)
        expect(User.first.valid_password?('useruser')).to eq(true)
      end
    end

    context 'if new passwords do not match' do
      it 'should return new passwords do not match' do
        params = { 'user[first_name]' => 'New OnShop',
                   'user[last_name]' => 'User',
                   'user[shipping_address]' => 'My Address',
                   'user[current_password]' => 'useruser',
                   'user[password]' => 'newpassword',
                   'user[password_confirmation]' => 'wrongnewpassword'
                 }

        put "/v1/user/users/update_profile", headers: @headers, params: params

        expect(response.code).to eq('422')
        expect(User.first.full_name).to eq(@user.full_name)
        expect(User.first.shipping_address).to eq(nil)
        expect(User.first.valid_password?('useruser')).to eq(true)
      end
    end

    context 'if current and new passwords are valid' do
      it 'should update info along with passwords' do
        params = { 'user[first_name]' => 'New OnShop',
                   'user[last_name]' => 'User',
                   'user[shipping_address]' => 'My Address',
                   'user[current_password]' => 'useruser',
                   'user[password]' => 'newpassword',
                   'user[password_confirmation]' => 'newpassword'
                 }

        put "/v1/user/users/update_profile", headers: @headers, params: params

        expect(response.code).to eq('200')
        expect(User.first.full_name).to eq('New OnShop User')
        expect(User.first.shipping_address).to eq('My Address')
        expect(User.first.valid_password?('newpassword')).to eq(true)
      end
    end
  end

  context 'with valid info (without password)' do
    it 'should update profile info' do
      params = { 'user[first_name]' => 'OnShop',
                 'user[last_name]' => 'User',
                 'user[shipping_address]' => 'My Address'
               }

      put "/v1/user/users/update_profile", headers: @headers, params: params

      expect(response.code).to eq('200')
      expect(User.first.full_name).to eq('OnShop User')
      expect(User.first.shipping_address).to eq('My Address')
      expect(User.first.valid_password?('useruser')).to eq(true)
    end
  end

  context 'with invalid info' do
    it 'should not update profile info or passwords' do
      params = { 'user[first_name]' => '',
                 'user[last_name]' => '',
                 'user[shipping_address]' => 'My Address',
                 'user[current_password]' => 'useruser',
                 'user[password]' => 'newpassword',
                 'user[password_confirmation]' => 'newpassword'
               }

      put "/v1/user/users/update_profile", headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(User.first.full_name).to eq(@user.full_name)
      expect(User.first.shipping_address).to eq(nil)
      expect(User.first.valid_password?('useruser')).to eq(true)
    end
  end
end
