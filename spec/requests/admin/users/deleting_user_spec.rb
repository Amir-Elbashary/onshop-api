require 'rails_helper'

RSpec.describe 'Deleting user by admin', type: :request do
  before do
    @app_token = create(:app_token)
    @admin = create(:admin)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @admin.authentication_token }
    @user = create(:user)
  end

  context 'with ID presented' do
    it 'should delete the user permanently' do
      expect(User.count).to eq(1)

      delete "/v1/admin/users/#{@user.id}", headers: @headers

      expect(response.code).to eq('200')
      expect(User.count).to eq(0)
    end
  end

  context 'with invalid ID presented' do
    it 'should respond with unprocessable entity' do
      expect(User.count).to eq(1)

      delete "/v1/admin/users/88", headers: @headers

      expect(response.code).to eq('404')
      expect(User.count).to eq(1)
    end
  end
end
