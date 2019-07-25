require 'rails_helper'

RSpec.describe Login, type: :model do
  describe 'Has associations' do
    it 'belongs to admin' do
      should belong_to(:admin).optional
    end

    it 'belongs to merchant' do
      should belong_to(:merchant).optional
    end

    it 'belongs to user' do
      should belong_to(:user).optional
    end
  end
end
