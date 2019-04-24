require 'rails_helper'

RSpec.describe Merchant, type: :model do
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
    it 'has many products' do
      should have_many :products
    end
  end
end
