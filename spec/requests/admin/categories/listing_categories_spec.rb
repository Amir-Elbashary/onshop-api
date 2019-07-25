require 'rails_helper'

RSpec.describe 'Listing categories', type: :request do
  before do
    @app_token = create(:app_token)
    @admin = create(:admin_with_logins)
    @category = create(:category)
    @sub_category1 = create(:category, parent_id: @category.id)
    @sub_category2 = create(:category, parent_id: @category.id)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @admin.logins.first.token }
  end

  describe 'when passing category ID' do
    context 'if it\'s main category ID' do
      it 'should show category info with sub categories' do
        params = { id: @category.id }

        get '/v1/admin/categories.json', headers: @headers, params: params
        response_body = JSON.parse(response.body)

        expect(response.code).to eq('200')
        expect(response_body['category_type']).to eq('main category')
        expect(response_body['main_category']['name_en']).to eq(@category.name_en)
        expect(response_body['sub_categories'].size).to eq(2)
      end
    end

    context 'if it\'s sub category ID' do
      it 'should show category info with it\'s parent name' do
        params = { id: @sub_category1.id }

        get '/v1/admin/categories.json', headers: @headers, params: params
        response_body = JSON.parse(response.body)

        expect(response.code).to eq('200')
        expect(response_body['category_type']).to eq('sub category')
        expect(response_body['sub_category']['name_en']).to eq(@sub_category1.name_en)
        expect(response_body['main_category']['name_en']).to eq(@category.name_en)
      end
    end
  end

  context 'when passing no parameters' do
    it 'should list all categories and it\'s sub categories' do
      get '/v1/admin/categories.json', headers: @headers
      response_body = JSON.parse(response.body)

      expect(response.code).to eq('200')
      expect(response_body.size).to eq(1)
      expect(response_body[0]['sub_categories'].size).to eq(2)
    end
  end

  context 'when passing ID which does not exist' do
    it 'should respond with not found' do
      params = { id: 8888 }

      get '/v1/admin/categories.json', headers: @headers, params: params

      expect(response.code).to eq('404')
    end
  end
end
