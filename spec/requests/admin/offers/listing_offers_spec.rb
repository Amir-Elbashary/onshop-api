require 'rails_helper'

RSpec.describe 'Listing offers as an admin', type: :request do
  before do
    @app_token = create(:app_token)
    @admin = create(:admin_with_logins)
    @parent_category = create(:category)
    @parent_offer = create(:offer, category: @parent_category)
    @sub_category1 = create(:category, parent_id: @parent_category.id)
    @parent_offer = create(:offer, category: @sub_category1)
    @sub_category2 = create(:category, parent_id: @parent_category.id)
    @parent_offer = create(:offer, category: @sub_category2)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @admin.logins.first.token }
  end

  context 'when presenting valid admin token' do
    it 'should list all categories offers' do
      get '/v1/admin/offers', headers: @headers

      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body.count).to eq(3)
    end
  end

  context 'when presenting invalid admin token' do
    it 'should not return any offers' do
      headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => 'invalid token' }
      get '/v1/admin/offers', headers: headers

      expect(response.code).to eq('401')
    end
  end
end
