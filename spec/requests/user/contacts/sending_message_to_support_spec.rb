require 'rails_helper'

RSpec.describe 'Sending message to support (Contact us)', type: :request do
  before do
    @app_token = create(:app_token)
    @user = create(:user)
    @headers = { 'X-APP-Token' => @app_token.token }
  end

  context 'with valid data' do
    it 'it should send message (Create contact)' do
      params = { 'contact[user_name]' => 'OnShop User',
                 'contact[email]' => 'email@exmaple.com',
                 'contact[phone_number]' => '0123456789',
                 'contact[message]' => 'This is a simple message' }

      post "/v1/user/contacts", headers: @headers, params: params

      expect(response.code).to eq('201')
      expect(Contact.first.user_name).to eq('OnShop User')
      expect(Contact.first.open?).to eq(true)
      expect(Contact.count).to eq(1)
    end
  end

  context 'with invalid data' do
    it 'should return error(s)' do
      params = { 'contact[user_name]' => '',
                 'contact[email]' => '',
                 'contact[phone_number]' => '',
                 'contact[message]' => 'This is a simple message' }

      post "/v1/user/contacts", headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Contact.count).to eq(0)
    end
  end
end
