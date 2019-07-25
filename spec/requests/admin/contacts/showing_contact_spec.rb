require 'rails_helper'

RSpec.describe 'Showing contact', type: :request do
  before do
    @app_token = create(:app_token)
    @admin = create(:admin_with_logins)
    @contact = create(:contact, status: 1)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @admin.logins.first.token }
  end

  context 'with valid ID' do
    it 'should show contact data' do
      get "/v1/admin/contacts/#{@contact.id}", headers: @headers
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body['email']).to eq(@contact.email)
    end
  end

  context 'with invalid ID' do
    it 'should return not found' do
      get "/v1/admin/contacts/8888", headers: @headers

      expect(response.code).to eq('404')
    end
  end
end
