require 'rails_helper'

RSpec.describe 'Editing categories', type: :request do
  before do
    @app_token = create(:app_token)
    @admin = create(:admin)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @admin.authentication_token }
    @category = create(:category)
    @sub_category1 = create(:category, parent_id: @category.id)
    @sub_category2 = create(:category, parent_id: @category.id)
  end

  context 'with valid data' do
    it 'should update category info' do
      params = { name: 'New name' }

      put "/v1/admin/categories/#{@category.id}", headers: @headers, params: params

      expect(response.code).to eq('200')
      expect(Category.roots.first.name).to eq('new name')
    end
  end

  context 'with invalid data' do
    it 'should not update category info' do
      params = { name: '' }

      put "/v1/admin/categories/#{@category.id}", headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Category.roots.first.name).to eq(@category.name)
    end
  end

  context 'with invalid ID' do
    it 'should respond with not found' do
      put "/v1/admin/categories/88", headers: @headers

      expect(response.code).to eq('404')
      expect(Category.roots.first.name).to eq(@category.name)
    end
  end
end
