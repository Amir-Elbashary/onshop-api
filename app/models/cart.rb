class Cart < ApplicationRecord
  enum state: %i[inactive active]

  has_many :items, dependent: :destroy
  belongs_to :user
end
