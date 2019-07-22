require 'rails_helper'

RSpec.describe Faq, type: :model do
  describe 'Require validations' do
    it 'should has an english question' do
      should validate_presence_of(:question_en)
    end

    it 'should has an english answer' do
      should validate_presence_of(:answer_en)
    end
  end
end
