class Order < ApplicationRecord
  enum payment_method: %i[cash paypal]
  enum status: %i[pending paid]

  validates :total_items, :total_price, presence: true
  validates :total_items, :total_price, numericality: { greater_than_or_equal_to: 0 }

  belongs_to :user
  belongs_to :cart
end
