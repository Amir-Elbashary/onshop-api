require 'rails_helper'

RSpec.describe Contact, type: :model do
	describe 'Require validations' do
    it 'should has an email' do
      should validate_presence_of(:email)
    end

    it 'should has an user name' do
      should validate_presence_of(:user_name)
    end

    it 'should has a message' do
      should validate_presence_of(:message)
    end
  end
end
