require 'rails_helper'

RSpec.describe Subscription, type: :model do
	describe 'Require validations' do
    it 'should has an email' do
      should validate_presence_of(:email)
    end

    it 'should has a unique email' do
      should validate_uniqueness_of(:email).case_insensitive
    end
  end
end
