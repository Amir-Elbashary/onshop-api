require 'rails_helper'

RSpec.describe User, type: :model do
	describe 'Require validations' do
    it 'should has an email' do
      should validate_presence_of(:email)
    end

    it 'should has a password' do
      should validate_presence_of(:password)
    end

    it 'should has a first name' do
      should validate_presence_of(:first_name)
    end

    it 'should has a last name' do
      should validate_presence_of(:last_name)
    end
  end

  describe 'Has associations' do
    it 'has many logins' do
      should have_many :logins
    end

    it 'has many orders' do
      should have_many :orders
    end

    it 'has many carts' do
      should have_many :carts
    end

    it 'has many favourites' do
      should have_many :favourites
    end

    it 'has many favourite products' do
      should have_many :favourite_products
    end

    it 'has many reviews' do
      should have_many :reviews
    end
  end
end
