require 'rails_helper'

RSpec.describe Coupon, type: :model do
  describe 'Require validations' do
    it 'should has a percentage' do
      should validate_presence_of(:percentage)
    end

    it 'should validates numericality of percentage' do
      validate_numericality_of(:percentage)
    end

    it 'should has a code' do
      # before_validation is used to ensure it's never nil
    end

    it 'should has a starts_at' do
      should validate_presence_of(:starts_at)
    end

    it 'should has a ends_at' do
      should validate_presence_of(:ends_at)
    end
  end

  describe 'Has associations' do
    # No Associations yet!
  end
end
