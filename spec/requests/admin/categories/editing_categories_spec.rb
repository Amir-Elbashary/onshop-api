require 'rails_helper'

RSpec.describe 'Editing categories', type: :request do
  before do
    @app_token = create(:app_token)
    @admin = create(:admin)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @admin.authentication_token }
    @category = create(:category)
    @category2 = create(:category)
    @sub_category1 = create(:category, parent_id: @category.id)
    @sub_category2 = create(:category, parent_id: @category.id)
  end

  context 'updating parent category with valid data' do
    it 'should update with unique name' do
      params = { name: 'New name',
                 name_ar: 'اسم جديد' }

      put "/v1/admin/categories/#{@category.id}", headers: @headers, params: params

      expect(response.code).to eq('200')
      expect(Category.roots.first.name_en).to eq('new name')
      expect(Category.roots.first.name_ar).to eq('اسم جديد')
    end

    it 'should not update with duplicated name' do
      params = { name: @category2.name }

      put "/v1/admin/categories/#{@category.id}", headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Category.roots.first.name).to eq(@category.name)
    end
  end

  context 'updating sub category with valid data' do
    it 'should update with unique name within the parent category' do
      params = { name: 'New name',
                 name_ar: 'اسم جديد'}

      put "/v1/admin/categories/#{@sub_category1.id}", headers: @headers, params: params

      expect(response.code).to eq('200')
      expect(Category.roots.first.children.first.name_en).to eq('new name')
      expect(Category.roots.first.children.first.name_ar).to eq('اسم جديد')
    end

    it 'should not update with duplicated name within the parent category' do
      params = { name: @sub_category2.name }

      put "/v1/admin/categories/#{@sub_category1.id}", headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Category.roots.first.children.first.name).to eq(@sub_category1.name)
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
