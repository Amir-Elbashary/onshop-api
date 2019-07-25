require 'rails_helper'

RSpec.describe 'Creating categories and sub categories together', type: :request do
  before do
    @app_token = create(:app_token)
    @admin = create(:admin_with_logins)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @admin.logins.first.token }
  end

  context 'with valid data' do
    it 'should create new category' do
      params = { parent_category: 'Electronics',
                 sub_categories: 'Computers,Phones,Laptops' }

      post '/v1/admin/categories.json', headers: @headers, params: params

      expect(response.code).to eq('200')
      expect(Category.roots.count).to eq(1)
      expect(Category.first.children.count).to eq(3)
    end
  end

  context 'with invalid data' do
    it 'should not create new category with an empty parent name' do
      params = { parent_category: '',
                 sub_categories: 'Computers,Phones,Laptops' }

      post '/v1/admin/categories.json', headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Category.roots.count).to eq(0)
    end

    it 'should not create new category with multiple parent names' do
      params = { parent_category: 'Electronics,Clothes',
                 sub_categories: 'Computers,Phones,Laptops' }

      post '/v1/admin/categories.json', headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Category.roots.count).to eq(0)
    end
  end

  context 'with duplicated data' do
    it 'should not create new category' do
      create(:category, name: 'electronics')

      params = { parent_category: 'Electronics',
                 sub_categories: 'Computers,Phones,Laptops' }

      post '/v1/admin/categories.json', headers: @headers, params: params

      expect(response.code).to eq('200')
      expect(Category.roots.count).to eq(1)
      expect(Category.roots.first.children.count).to eq(3)
    end
  end
end

RSpec.describe 'Creating parent category only' do
  before do
    @app_token = create(:app_token)
    @admin = create(:admin_with_logins)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @admin.logins.first.token }
  end

  context 'with valid data' do
    it 'should create new category' do
      params = { parent_category: 'Electronics' }

      post '/v1/admin/categories.json', headers: @headers, params: params

      expect(response.code).to eq('200')
      expect(Category.roots.count).to eq(1)
      expect(Category.first.children.count).to eq(0)
    end
  end

  context 'with invalid data' do
    it 'should not create new category with an empty parent name' do
      params = { parent_category: '' }

      post '/v1/admin/categories.json', headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Category.roots.count).to eq(0)
    end

    it 'should not create new category with multiple parent names' do
      params = { parent_category: 'Electronics,Clothes' }

      post '/v1/admin/categories.json', headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Category.roots.count).to eq(0)
    end
  end

  context 'with duplicated data' do
    it 'should not create new category' do
      create(:category, name: 'Electronics')

      params = { parent_category: 'Electronics' }

      post '/v1/admin/categories.json', headers: @headers, params: params

      expect(response.code).to eq('200')
      expect(Category.roots.count).to eq(1)
    end
  end
end

RSpec.describe 'Creating sub categories to and existing category' do
  before do
    @app_token = create(:app_token)
    @admin = create(:admin_with_logins)
    @headers = { 'X-APP-Token' => @app_token.token, 'X-User-Token' => @admin.logins.first.token }
  end

  context 'with valid data' do
    it 'should create new sub categories' do
      @category = create(:category, name: 'electronics')

      params = { parent_category: 'electronics',
                 sub_categories: 'Computers,Phones,Laptops' }

      post '/v1/admin/categories.json', headers: @headers, params: params

      expect(response.code).to eq('200')
      expect(Category.roots.count).to eq(1)
      expect(Category.first.children.count).to eq(3)
    end
  end

  context 'with invalid data' do
    it 'should not create new category' do
      @category = create(:category, name: 'electronics')

      params = { parent_category: '',
                 sub_categories: 'Computers,Phones,Laptops' }

      post '/v1/admin/categories.json', headers: @headers, params: params

      expect(response.code).to eq('422')
      expect(Category.roots.count).to eq(1)
      expect(Category.first.children.count).to eq(0)
    end
  end

  context 'with duplicated data' do
    it 'should not create new category' do
      @category = create(:category, name: 'electronics')
      @sub_category1 = create(:category, name: 'Computers', parent_id: @category.id)
      @sub_category2 = create(:category, name: 'mobile Phones', parent_id: @category.id)

      # Spaces are put intentionly to make sure
      # they won't affect the response results
      params = { parent_category: 'electronics',
                 sub_categories: 'Computers, mobile  phones ,Laptops ' }

      post '/v1/admin/categories.json', headers: @headers, params: params

      expect(response.code).to eq('200')
      expect(Category.roots.count).to eq(1)
      expect(Category.first.children.count).to eq(3)
    end
  end
end
