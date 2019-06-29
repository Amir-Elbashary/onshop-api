require 'rails_helper'

RSpec.describe Review, type: :model do
  describe 'Require validations' do
    it 'should has a rating' do
      should validate_presence_of(:rating)
    end

    it 'should has a positive rating' do
      should validate_numericality_of(:rating)
    end
  end

  describe 'Has associations' do
    it 'belongs to user' do
      should belong_to(:user)
    end

    it 'belongs to product' do
      should belong_to(:product)
    end
  end
end
