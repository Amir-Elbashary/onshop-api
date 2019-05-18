require 'rails_helper'

RSpec.describe Favourite, type: :model do
  describe 'Has associations' do
    it 'belongs to user' do
      should belong_to(:user)
    end

    it 'belongs to favourited' do
      should belong_to(:favourited)
    end
  end
end
