class Review < ApplicationRecord

  validates :rating, presence: true
  validates :rating, numericality: { greater_than_or_equal_to: 0 }

  belongs_to :user
  belongs_to :product
end
