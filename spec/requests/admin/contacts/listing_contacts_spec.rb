require 'rails_helper'

RSpec.describe 'Listing contacts', type: :request do
  before do
    @app_token = create(:app_token)
    @admin = create(:admin_with_logins)
    @opened_contact1 = create(:contact, status: 1)
    @opened_contact2 = create(:contact, status: 1)
    @opened_contact3 = create(:contact, status: 1)
    @closed_contact1 = create(:contact, status: 0)
    @closed_contact2 = create(:contact, status: 0)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @admin.logins.first.token }
  end

  context 'if filter "opened" presented' do
    it 'should list all opened contacts only' do
      params = { filter: 'opened' }

      get '/v1/admin/contacts.json', headers: @headers, params: params
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body.size).to eq(3)
    end
  end

  context 'if filter "closed" presented' do
    it 'should list all closed contacts only' do
      params = { filter: 'closed' }

      get '/v1/admin/contacts.json', headers: @headers, params: params
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body.size).to eq(2)
    end
  end

  context 'if no filter presented' do
    it 'should list all contacts' do
      params = { filter: '' }

      get '/v1/admin/contacts.json', headers: @headers, params: params
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body.size).to eq(5)
    end
  end
end
