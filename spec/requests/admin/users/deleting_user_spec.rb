require 'rails_helper'

RSpec.describe 'Deleting user by admin', type: :request do
  before do
    @app_token = create(:app_token)
    @admin = create(:admin_with_logins)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @admin.logins.first.token }
    @user = create(:user)
  end

  context 'with ID presented' do
    it 'should delete the user permanently' do
      expect(User.count).to eq(1)

      delete "/v1/admin/users/#{@user.id}", headers: @headers

      expect(response.code).to eq('200')
      expect(User.count).to eq(0)
    end

    it 'should not delete user is it\'s associated with other objects' do
      @cart = create(:cart, user: @user, status: 0)
      @variant1 = create(:variant, quantity: 2, price: 100)
      @variant2 = create(:variant, quantity: 1, price: 200)
      @item1 = create(:item, cart: @cart, variant: @variant1, quantity: @variant1.quantity)
      @item2 = create(:item, cart: @cart, variant: @variant2, quantity: @variant2.quantity)
      @order = create(:order, cart: @cart, user: @user)

      expect(User.count).to eq(1)

      delete "/v1/admin/users/#{@user.id}", headers: @headers

      expect(response.code).to eq('403')
      expect(User.count).to eq(1)
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
