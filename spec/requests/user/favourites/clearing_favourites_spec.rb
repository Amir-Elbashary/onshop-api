require 'rails_helper'

RSpec.describe 'Clearing favourite list', type: :request do
  before do
    @app_token = create(:app_token)
    @user = create(:user_with_logins)
    @product1 = create(:product)
    @product2 = create(:product)
    Favourite.create(user: @user, favourited: @product1)
    Favourite.create(user: @user, favourited: @product2)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @user.logins.first.token }
  end
  
  context 'while providing valid user token' do
    it 'should clear his favourites if there is any favourites' do
      expect(@user.favourites.count).to eq(2)

      post "/v1/user/users/clear_favourites", headers: @headers

      expect(response.code).to eq('200')
      expect(@user.favourites.count).to eq(0)
    end
  end

  context 'while providing invalid user token' do
    it 'should respond with unauthorized' do
      headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => 'invalid token' }

      post "/v1/user/users/clear_favourites", headers: headers

      expect(response.code).to eq('401')
      expect(User.first.favourites.count).to eq(2)
    end
  end
end
